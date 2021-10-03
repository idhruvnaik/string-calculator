require 'pry'

class LandingController < ActionController::Base
  protect_from_forgery with: :null_session

  def index
  end

  def add
    negatives = []
    result = 0
    text = params['text']

    numbers = text.gsub(/[^0-9]/, '')
    numbers.split('').each do |n|
      index = text.index(n)
      if index != 0 && (text[(index - 1)]) == '-'
        negatives << n
      else
        result = result + n.to_f
      end
    end

    negatives = negatives.uniq

    if negatives.length == 1
      render_error_json 'Negatives not allowed'
      return
    elsif negatives.length > 1
      render_error_json "#{negatives.to_sentence(words_connector: ', ', last_word_connector: ' and ')} are negative numbers"
      return
    end

    render_result_json result
  end

  def render_result_json object
    response = {status: 'success', contents: object}
    render json: response
  end

  def render_error_json message
    response = {status: 500, message: message}
    render json: response, status: 500
  end
end
