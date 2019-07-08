# frozen_string_literal: true

module IssueBadge
  module MyControllerPatch
    extend ActiveSupport::Concern

    def account
      user = User.current
      @issue_badge = IssueBadgeUserSetting.find_or_create_by_user_id(user)
      if request.put?
        begin
          logger.info(badge_params)
          logger.warn "Can't save IssueBadge." unless @issue_badge.update(badge_params)
        rescue StandardError => e
          logger.warn "Can't save IssueBadge. #{e.message}"
        end
      end
      super
    end

    private

    def badge_params
      params.require(:issue_badge).permit(:enabled, :show_assigned_to_group, :badge_order)
    end
  end
end

MyController.prepend IssueBadge::MyControllerPatch
