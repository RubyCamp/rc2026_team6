class TutorialsController < ApplicationController
  def index
    @profiles = TutorialProfile.published
      if params[:category].present?
        @profiles = @profiles.select do |profile|
          profile.category == params[:category]
        end
      end

    @profiles = @profiles.sort_by(&:name)
  end



  def debug
    @profile = TutorialProfile.find(1)
  end
end
