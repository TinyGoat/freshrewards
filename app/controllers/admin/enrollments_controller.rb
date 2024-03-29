class Admin::EnrollmentsController < Admin::BaseController
  layout 'admin'

  def new
  end

  def create
    EnrollmentFile.process! params[:enrollment_file].tempfile

    redirect_to new_admin_enrollment_path, notice: 'You enrollment file was processed successfully'
  end
end

