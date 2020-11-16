class Tl3Constraint
  def matches?(request)
    SiteSetting.tl3_enabled
  end
end
