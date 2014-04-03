class ExceptionsController < ApplicationController

  before_filter :authenticate_admin, :except => [ :report ]

  def report
    JavascriptExceptionMailer.report(params[:msg]).deliver

    render text: 'Exception reported'
  end

end
