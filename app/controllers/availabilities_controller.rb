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

  def edit
    @availability = Availability.find(params[:id])
    @staff_members = StaffMember.all
  end

  def update
    logger.debug "Availability params: #{availability_params.inspect}"
    logger.debug("Updating availability: #{params[:id]}")
    @availability = Availability.find(params[:id])
    @staff_members = StaffMember.all
    if @availability.update(availability_params)
      redirect_to availabilities_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Availability.remove!(id: params[:id])
    redirect_to availabilities_path
  end

  private
  def availability_params
    params.require(:availability).permit(:staff_member_id, :starts_at, :ends_at, :notes)
  end
end
