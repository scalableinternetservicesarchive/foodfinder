class TimelineController < ApplicationController
  include ApplicationHelper
  include TimelineHelper

  def show
    # lat = get_lat(request.remote_ip.to_s)
    # lng = get_lng(request.remote_ip.to_s)
    lat = '34.413347'.to_f
    lng = '-119.855441'.to_f
    distance_miles = 1.0
    @deals_within_proximity = Deal.where("sqrt(power(#{lat}-latitude,2) + power(#{lng}-longitude,2)) < #{0.0164 * distance_miles}").paginate(:page => params[:page], :per_page => 10)
    @address_data = get_address_data
    render 'show'
  end

  def load_deals
  	distance_miles = params[ :distance_from_address ].to_f()
    # if params[ :street_address ].present?
    # 	location = Geocoder.search( params[ :street_address ] )
    # else
    #   location = Geocoder.search( get_lat(request.remote_ip.to_s) + ',' + get_lng(request.remote_ip.to_s) )
    # end
    # lat = location[0].latitude
    # lng = location[0].longitude
    lat = '34.413347'.to_f
    lng = '-119.855441'.to_f
    @deals_within_proximity = Deal.where("sqrt(power(#{lat}-latitude,2) + power(#{lng}-longitude,2)) < #{0.0164 * distance_miles} AND (#{params[:food_type] == 'Any'} OR food_type='#{params[:food_type].to_s}')").paginate(:page => params[:page], :per_page => 10)
    @address_data = get_address_data
  	render 'show'
  end

  private

  def get_address_data
    # lat_lng_present = Rails.cache.fetch('lat' + request.remote_ip.to_s).present? && Rails.cache.fetch('lng'+ request.remote_ip.to_s).present?
    # address_valid = false
    # if lat_lng_present
    #   geocoder_result = Geocoder.search( get_lat(request.remote_ip.to_s) + ',' + get_lng(request.remote_ip.to_s) )
    #   address_valid = geocoder_result[0].nil? ? false : true
    # end
    # address_data = address_valid ? geocoder_result[ 0 ].data["formatted_address"] : Geocoder.search( get_lat(request.remote_ip.to_s) + ',' + get_lng(request.remote_ip.to_s) )[ 0 ].data["formatted_address"]
    address_data = ''
  end

end

