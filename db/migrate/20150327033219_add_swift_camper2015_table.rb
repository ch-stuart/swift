class AddSwiftCamper2015Table < ActiveRecord::Migration
  def change
    create_table :campers do |t|

      # Is this your first bike-overnight?
      t.text :is_first_bike_overnight
      # Where are you heading on your Swift Campout, and how far is it to your destination?
      t.text :campout_location_and_miles
      # Tell us about your favorite piece of gear
      t.text :favorite_gear
      # Why do you love camping by bicycle?
      t.text :why_do_you_love_bike_camping
      # Are you heading out with a posse? What’s your crew’s name?
      t.text :is_group_camping
      # What kind of bike are you riding?
      t.text :which_bike
      # What’s your go-to camp meal?
      t.text :favorite_camp_meal
      # How did you hear about Swift Campout?
      t.text :hear_about

      t.integer :user_id

      t.timestamps
    end
  end
end

