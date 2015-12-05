class TimelineController < ApplicationController

  def show
    # @lat = Rails.cache.fetch('lat').to_f
    # @lng = Rails.cache.fetch('lng').to_f
    # @distance_miles = 1.0
    # # @deals_within_proximity = Deal.where("sqrt(power(#{@lat}-latitude,2) + power(#{@lng}-longitude,2)) < #{0.0164 * @distance_miles}").paginate(:page => params[:page], :per_page => 10)
    # @deals_within_proximity = Deal.where("sqrt(power(#{@lat}-latitude,2) + power(#{@lng}-longitude,2)) < #{0.0164 * @distance_miles}")

    # render 'show'
    # Render timeline and pass all necessary info to the view.
    @deals_within_proximity = []
    @lat = Rails.cache.fetch('lat').to_f
    @lng = Rails.cache.fetch('lng').to_f
    @distance_miles = 1.0
    distance_meters = @distance_miles * 1609.34
    Deal.all.each do |deal|
      if coordinate_distance([deal.latitude, deal.longitude],[@lat,@lng]) <= distance_meters
        @deals_within_proximity.append(deal)
      end
    end
    render 'show'
  end

  def load_deals
  	# @distance_miles = params[ :distance_from_address ].to_f()

   #  if params[ :street_address ].present?
   #  	location = Geocoder.search( params[ :street_address ] )
   #  elsif params[ :lat_lng ].present?
   #    location = Geocoder.search( params[ :lat_lng ] )
   #  else
   #    location = Geocoder.search( Rails.cache.fetch('lat') + ',' + Rails.cache.fetch('lng') )
   #  end

   #  @lat = location[0].latitude
   #  @lng = location[0].longitude
   #  # @deals_within_proximity = Deal.where("sqrt(power(#{@lat}-latitude,2) + power(#{@lng}-longitude,2)) < #{0.0164 * @distance_miles} AND (#{params[:food_type] == 'Any'} OR food_type='#{params[:food_type].to_s}')").paginate(:page => params[:page], :per_page => 10)
   #  @deals_within_proximity = Deal.where("sqrt(power(#{@lat}-latitude,2) + power(#{@lng}-longitude,2)) < #{0.0164 * @distance_miles} AND (#{params[:food_type] == 'Any'} OR food_type='#{params[:food_type].to_s}')")

  	# render 'show'
    @distance_miles = params[ :distance_from_address ].to_f()
    distance_meters = @distance_miles  * 1609.34

    if params[ :street_address ].present?
      location = Geocoder.search( params[ :street_address ] )
    elsif params[ :lat_lng ].present?
      location = Geocoder.search( params[ :lat_lng ] )
    else
      location = Geocoder.search( Rails.cache.fetch('lat') + ',' + Rails.cache.fetch('lng') )
    end

    @deals_within_proximity = []
    @lat = location[0].latitude
    @lng = location[0].longitude

    Deal.all.each do |deal|
      if coordinate_distance([deal.latitude, deal.longitude],[@lat,@lng]) <= distance_meters
        if params[:food_type] == 'Any' || deal.food_type == params[:food_type]
          @deals_within_proximity.append(deal)
        end
      end
    end
    render 'show'
  end

end

private


  def coordinate_distance(loc1, loc2)
    #puts loc1
    #puts loc2
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0] - loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1] - loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in meters
  end

