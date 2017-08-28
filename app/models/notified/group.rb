class Notified::Group < Notified::Base
  def initialize(model, notifier)
    super(model).tap { @notifier = notifier }
  end

  def id
    model.id
  end

  def title
    model.full_name
  end

  def subtitle
    I18n.t(:"notified.group_users", count: notified_ids.length)
  end

  def icon_url
    model.logo.presence&.url(:card) || '/img/default-logo-medium.png'
  end

  def notified_ids
    @notified_ids ||= Queries::UsersByVolumeQuery
                        .normal_or_loud(model)
                        .without(@notifier)
                        .pluck(:id)
  end
end