class Admin::EnrollmentsController < ActionController::Base
  layout false

  def new

  end

  def create
    EnrollmentFile.process! params[:enrollment_file].tempfile

    redirect_to new_admin_enrollment_path, notice: 'You enrollment file was processed successfully'
  end
end

