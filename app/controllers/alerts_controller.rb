class AlertsController < ApplicationController
  before_action :set_alert, only: [:show, :edit, :update, :destroy]

  # 
  # Devise Auth
  before_filter :authenticate_user!, :load_tap
  
  # 
  # cancan auth
  load_and_authorize_resource

  # GET /alerts
  # GET /alerts.json
  def index

    user = current_user

    @alerts = Alert.where(["user_id = ?", user.id])
    
  end

  # GET /alerts/1
  # GET /alerts/1.json
  def show

    ################################################
    # Real show action
    # @page = 

    self.display_results(params['page'])

    @title = 'Latest results '
    if (!@alert.terms.blank?)
      @title << 'for '+@alert.terms
    end

    if (!@alert.zipcode.blank?)
      @title << ' near '+@alert.zipcode
    end

    @page = @next_page - 1
    @prev_page = @page - 1
    
    # 
    # The best way to not write it twice
    @pager = Array.new

    if ((@next_page >= 0) && (@prev_page < 0))
      # page = @page.to_i
      # if page >= 1
        @pager << ActionController::Base.helpers.link_to("Previous Page", '', :class => 'button disabled small')
      # end

      # @pager << @prev_page.to_s + '|' + @page.to_s + '|' + @next_page.to_s
      # if (@next_page != 0)
        @pager << ActionController::Base.helpers.link_to('Next Page', url_for(:page => @next_page.to_s), :class => 'button small')
      # end
    elsif ((@next_page >= 1) && @page > 0)
      @pager << ActionController::Base.helpers.link_to("Previous Page", url_for(:page => @prev_page.to_s), :class => 'button small')
      # end
      # @pager << @page
      # if (@next_page != 0)
      @pager << ActionController::Base.helpers.link_to('Next Page', url_for(:page => @next_page.to_s), :class => 'button small')
    end
    # @pager << @page
    # @pager << @next_page
    #######################################################

    # self.send_results

  end

  # GET /alerts/new
  def new
    # @alert = Alert.new(alert_params)

  end

  # GET /alerts/1/edit
  def edit
    
    # @tap_categories = @tap.categories
    # @tap_radii = @tap.radii
    
  end

  # POST /alerts
  # POST /alerts.json
  def create
    @alert = Alert.new(alert_params)

    @alert.user_id = current_user.id
    @alert.scheduled_time = Time.new + 2.minutes

    current_user.time_zone = cookies['browser.timezone']
    current_user.save

    respond_to do |format|
      if @alert.save
        format.html { redirect_to alert_path(@alert), notice: 'Alert was successfully created.' }
        format.json { render action: 'show', status: :created, location: @alert }
        # 
        # 
        @alert.extend AlertsHelper
        @alert.geocode
        # 
        # 
      else
        format.html { render action: 'new' }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alerts/1
  # PATCH/PUT /alerts/1.json
  def update

    @alert.scheduled_time = Time.new + 2.minutes

    respond_to do |format|
      if @alert.update(alert_params)
        format.html { redirect_to alert_path(@alert), notice: 'Alert was successfully updated.' }
        format.json { head :no_content }
        # 
        # 
        @alert.extend AlertsHelper
        @alert.geocode
        # 
        # 
      else
        format.html { render action: 'edit' }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
    @alert.destroy
    respond_to do |format|
      format.html { redirect_to alerts_url }
      format.json { head :no_content }
    end
  end


  def display_results(page = nil)

    # @debug = page.to_s

    @query = @tap.build_query(@alert, 0, page)

    results = @tap.make_request

    # @debug = cookies['browser.timezone']

    results['postings'].each do |r|
      # Fix $-1.0
      if (r['price'].blank?)
        r['price'] = '$--'
      elsif (r['price'] <= 0)
        r['price'] = '$--'
      elsif
        r['price'] = '$'+r['price'].to_s
      end

      # @debug = current_user.time_zone

      # r['timestamp'] = 

    end

    @results = results['postings']
    # @tap_results = results.inspect
    # @query = @tap.get_query
    @next_page = results['next_page']

    # @debug = results.to_s
    # @debug = page.to_s + '|' + @next_page.to_s

  end


  def load_tap
      require 'Tap'
      @tap = Tap.new
      @tap_categories = @tap.categories 
      @tap_radii = @tap.radii
      @tap_time_options = @tap.time_options
    end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_alert
      @alert = Alert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alert_params
      params.require(:alert).permit(:zipcode, :radius, :price_min, :price_max, :terms, :category, :run_every)
    end
end
