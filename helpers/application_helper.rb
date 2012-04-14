# -*- encoding : utf-8 -*-

#class RpControl < Sinatra::Base

  helpers do

    def week_numbers_with_dates
      (1..52).inject({}) do |result,number|
        last_week_for_control = Date.today.cweek - 4
        year = (number < last_week_for_control) ? (Date.today.cwyear + 1) : Date.today.cwyear
        week_to_date = Date.commercial(year,number)
        result[number] = week_to_date
        result
      end
    end

    def current_month_number
      l(Date.today, '%m').to_i - 1
    end

    def months_names
      ['Január','Február','Marec','Apríl','Máj','Jún','Júl','August','September','Október','November','December']
    end

    def month_name(index)
      months_names[index]
    end

    def paginate_labels
      {:previous_label => '<<', :next_label => '>>'}
    end

    def is_current_path?(path)
      request.path == path ? 'active' : ''
    end

    def boolean_label_for(state,conditions={})
      if conditions.key?(:represented_if) && !conditions[:represented_if]
        '<span class="label">N/A</span>'
      elsif state
        '<span class="label label-success">ANO</span>'
      else
        '<span class="label label-important">NIE</span>'
      end
    end

    def flash_messages
      return if flash.empty?
      if flash.key?(:error)
        html_class = "alert-error"
        html_message = flash[:error]
      elsif flash[:success]
        html_class = "alert-success"
        html_message = flash[:success]
      elsif flash[:warning]
        html_class = "alert"
        html_message = flash[:warning]
      end

      "<div class='alert #{html_class}'>
        <a class='close'>x</a>
        #{html_message}
      </div>"
    end

  end

#end
