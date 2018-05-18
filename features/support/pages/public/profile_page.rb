module Pages
  module Public
    class ProfilePage < BasePage
      text_field :first_name_field, id: 'user_first_name'
      text_field :last_name_field, id: 'user_last_name'
      text_field :location_field, id: 'user_location'
      select_list :timezone_field, id: 'user_timezone'
      text_field :cv_url_field, id: 'user_cv_url'
      button :submit_profile, value: 'Submit'

      def fill_and_submit_form(attributes)
        raise 'Empty profile form attributes' if attributes.empty?

        attributes.each do |field_name, value|
          self.public_send("#{field_name}=", value)
        end
        submit_profile

        @page = Pages::Public::ScreeningPage.new(@browser)
      end
    end
  end
end
