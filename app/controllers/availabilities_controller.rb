class AvailabilitiesController < ApplicationController
  def index
    @availabilities = Availability.all
  end

  def new
    @availability = Availability.new
    @staff_members = StaffMember.all
    @time_sections = { "Morning" => false, "Afternoon" => false, "Evening" => false }
  end

  def create
    @availability = Availability.new(availability_params)
    @staff_members = StaffMember.all
    if @availability.save
      redirect_to availabilities_path
    else
      render :new
    end
  end

  private
  def availability_params
    params.require(:availability).permit(:staff_member_id, :starts_at, :ends_at, :notes)
  end
end
