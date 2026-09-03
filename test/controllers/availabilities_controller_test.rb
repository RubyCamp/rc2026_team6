require "test_helper"

class AvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @staff_member = StaffMember.create!(name: "テストスタッフ")
    @availability = Availability.create!(
      staff_member: @staff_member,
      starts_at: Time.zone.local(2026, 9, 2, 9),
      ends_at: Time.zone.local(2026, 9, 2, 17),
      status: :available
    )
  end

  test "勤務希望を削除して一覧へ戻る" do
    assert_difference("Availability.count", -1) do
      assert_difference("ChangeEvent.count", 1) do
        delete availability_path(@availability)
      end
    end

    assert_redirected_to availabilities_path
    assert_raises ActiveRecord::RecordNotFound do
      @availability.reload
    end
  end

  test "新規入力と更新の日付欄が365日範囲になっている" do
    minimum_date = Date.current.to_s
    maximum_date = (Date.current + 364.days).to_s

    get new_availability_path
    assert_select "input[type=date][name=?][min=?][max=?]",
                  "availability[starts_at]", minimum_date, maximum_date

    get edit_availability_path(@availability)
    assert_select "input[type=date][name=?][min=?][max=?]",
                  "availability[starts_at]", minimum_date, maximum_date
  end
end
