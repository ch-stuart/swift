class ExceptionsController < ApplicationController

  def report
    JavascriptExceptionMailer.report(params[:msg]).deliver_now
    render text: 'Exception reported'
  end

end
