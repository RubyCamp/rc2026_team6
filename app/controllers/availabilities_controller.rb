class AvailabilitiesController < ApplicationController
  def index
    require Rails.root.join("staff_member") unless defined?(StaffMember)
    @current_month = requested_month
    @staff_member_id = params[:staff_member_id].presence
    @calendar_start = @current_month.beginning_of_month - @current_month.beginning_of_month.wday.days
    calendar_end = @calendar_start + 42.days
    @calendar_days = (@calendar_start...calendar_end).to_a
    availabilities = Availability.includes(:staff_member)
      .where(starts_at: @calendar_start...calendar_end)
      .order(:starts_at)
    availabilities = availabilities.where(staff_member_id: @staff_member_id) if @staff_member_id
    @availabilities_by_date = availabilities.group_by { |availability| availability.starts_at.to_date }
    @staff_members = StaffMember.order(:name)
    monthly_availabilities = Availability
      .where(starts_at: @current_month...@current_month.next_month)
      .order(:starts_at)
    monthly_availabilities = monthly_availabilities.where(staff_member_id: @staff_member_id) if @staff_member_id
    @monthly_availabilities_by_staff = monthly_availabilities.group_by(&:staff_member_id)
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

  def requested_month
    Date.strptime(params[:month].to_s, "%Y-%m").beginning_of_month
  rescue Date::Error
    Date.current.beginning_of_month
  end

  def availability_params
    attributes = params.require(:availability).permit(
      :staff_member_id,
      :work_date,
      :starts_at,
      :ends_at,
      :status,
      :notes
    )

    work_date = Date.iso8601(attributes.delete(:work_date).to_s)
    starts_at = Time.zone.parse("#{work_date} #{attributes.delete(:starts_at)}")
    ends_at = Time.zone.parse("#{work_date} #{attributes.delete(:ends_at)}")
    puts ends_at
    attributes.merge(starts_at: starts_at, ends_at: ends_at)
  rescue ArgumentError, TypeError
    attributes
  end
end
