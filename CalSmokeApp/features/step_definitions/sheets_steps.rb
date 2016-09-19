module CalSmoke
  module Sheets

    def sheet_query
      if ios7?
        'UIActionSheet'
      else
        "view:'_UIAlertControllerView'"
      end
    end

    def sheet_exists?(sheet_title=nil)
      if sheet_title.nil?
        !query(sheet_query).empty?
      else
        !query("#{sheet_query} descendant label marked:'#{sheet_title}'").empty?
      end
    end

    def wait_for_sheet
      timeout = 30
      message = "Waited #{timeout} seconds for a sheet to appear"
      options = {timeout: timeout, timeout_message: message}

      wait_for(options) do
        sheet_exists?
      end
    end

    def wait_for_sheet_with_title(sheet_title)
      timeout = 30
      message = "Waited #{timeout} seconds for a sheet with title '#{sheet_title}' to appear"
      options = {timeout: timeout, timeout_message: message}

      wait_for(options) do
        sheet_exists?(sheet_title)
      end
    end

    def tap_sheet_button(button_title)
      wait_for_sheet

      if ios7?
        query = "UIActionSheet child button child label marked:'#{button_title}'"
      else
        query = "view:'_UIAlertControllerActionView' marked:'#{button_title}'"
      end

      touch(query)
    end
  end
end

World(CalSmoke::Sheets)

When(/^I touch the show sheet button$/) do
  wait_for_element_exists("view marked:'show sheet'")
  touch("view marked:'show sheet'")
end

Then(/^I see a sheet$/) do
  wait_for_sheet
end

Then(/^I see the "([^"]*)" sheet$/) do |sheet_title|
  wait_for_sheet_with_title(sheet_title)
end

Then(/^I can dismiss the sheet with the Cancel button$/) do
  tap_sheet_button('Cancel')
end
