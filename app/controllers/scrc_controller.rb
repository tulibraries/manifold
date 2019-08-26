# frozen_string_literal: true

class ScrcController < ApplicationController
  include RedirectLogic

  def show
    if matches_finding_aid
      redirect_to(finding_aid_path(@finding_aid), status: 301)
    else
      redirect_or_404
    end
  end

  def matches_finding_aid
    @finding_aid = FindingAid.find_by_path(legacy_path)
    !!@finding_aid
  end
end
