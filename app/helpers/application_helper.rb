module ApplicationHelper
  MINUTE_IN_SECONDS = 60
  HOUR_IN_SECONDS = MINUTE_IN_SECONDS * 60
  DAY_IN_SECONDS = HOUR_IN_SECONDS * 24
  MONTH_IN_SECONDS = DAY_IN_SECONDS * 30
  YEAR_IN_SECONDS = MONTH_IN_SECONDS * 12

  def fixed_url(str)
    str.start_with?('https://') ? str : "https://#{str}"
  end

  def display_datetime(dt)
    if logged_in? and !current_user.time_zone.blank?
      dt = dt.in_time_zone(current_user.time_zone)
    end
    dt.strftime("%m/%d/%Y %l:%M%P %Z")
  end

  def time_difference(dt)
    diff = TimeDifference.between(Time.zone.now, dt).in_seconds.to_i

    case
    when diff < MINUTE_IN_SECONDS
      "#{diff.to_i} " + "second".pluralize(diff)
    when diff.between?(MINUTE_IN_SECONDS, HOUR_IN_SECONDS)
      diff = TimeDifference.between(Time.zone.now, dt).in_minutes.to_i
      "#{diff} " + "minute".pluralize(diff)
    when diff.between?(HOUR_IN_SECONDS, DAY_IN_SECONDS)
      diff = TimeDifference.between(Time.zone.now, dt).in_hours.to_i
      "#{diff} " + "hour".pluralize(diff)
    when diff.between?(DAY_IN_SECONDS, MONTH_IN_SECONDS)
      diff = TimeDifference.between(Time.zone.now, dt).in_days.to_i
      "#{diff} " + "day".pluralize(diff)
    when diff.between?(MONTH_IN_SECONDS, YEAR_IN_SECONDS)
      diff = TimeDifference.between(Time.zone.now, dt).in_months.to_i
      "#{diff} " + "moneth".pluralize(diff)
    when diff > YEAR_IN_SECONDS
      diff = TimeDifference.between(Time.zone.now, dt).in_years.to_i
      "#{diff} " + "year".pluralize(diff)
    end
  end

  def total_karma(user)
    posts_karma(user) + comments_karma(user)
  end

  private

  def posts_karma(user)
    karma = 0
    user.posts.each do |post|
      post.votes.each do |votes|
        votes.vote ? karma += 1 : karma -= 1
      end
    end
    karma
  end

  def comments_karma(user)
    karma = 0
    user.comments.each do |comment|
      comment.votes.each do |votes|
        votes.vote ? karma += 1 : karma -= 1
      end
    end
    karma
  end
end
