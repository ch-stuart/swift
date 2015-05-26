class Camper < ActiveRecord::Base

  belongs_to :user

  def self.qa_map
    return {
      is_first_bike_overnight: "Is this your first bike-overnight?",
      campout_location_and_miles: "Where are you heading on your Swift Campout, and how far is it to your destination?",
      favorite_gear: "Tell us about your favorite piece of gear",
      why_do_you_love_bike_camping: "Why do you love camping by bicycle?",
      is_group_camping: "Are you heading out with a posse? What's your crew's name?",
      which_bike: "What kind of bike are you riding?",
      favorite_camp_meal: "What's your go-to camp meal?",
      hear_about: "How did you hear about Swift Campout?"
    }
  end

end
