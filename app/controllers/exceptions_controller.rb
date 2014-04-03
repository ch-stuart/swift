class ExceptionsController < ApplicationController

  def report
    ExceptionNotifier.notify_exception('Exception',
      :env => request.env, :data => {:message => params[:msg]})

    render text: 'Exception reported'
  end

end
