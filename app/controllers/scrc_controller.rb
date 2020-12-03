# frozen_string_literal: true

class ScrcController < ApplicationController
  include RedirectLogic

  def show
    if matches_finding_aid
      redirect_to(finding_aid_path(@finding_aid), status: :moved_permanently)
    else
      redirect_or_404(nil)
    end
  end


  def matches_finding_aid
    @finding_aid = FindingAid.find_by(path: finding_aid_legacy_path)
    !!@finding_aid
  end

  def finding_aid_legacy_path
    # Finding aid entities path do not have the starting "/scrc/"
    unless legacy_path.include? "collections"
      legacy_path.gsub(/^\/scrc\//, "")
    else
      legacy_path.gsub(/^\/collections\/scrc\//, "")
    end
  end
end
