class ExceptionsController < ApplicationController

  def report
    JavascriptExceptionMailer.report(params[:msg]).deliver
    render text: 'Exception reported'
  end

end
