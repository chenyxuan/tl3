# frozen_string_literal: true

# name: tl3
# about: Show trust level 3 requirements to users
# version: 0.1
# authors: chenyxuan
# url: https://github.com/chenyxuan

register_asset 'stylesheets/common/tl3.scss'
register_asset 'stylesheets/desktop/tl3.scss', :desktop
register_asset 'stylesheets/mobile/tl3.scss', :mobile

enabled_site_setting :tl3_enabled

PLUGIN_NAME ||= 'Tl3'

load File.expand_path('lib/tl3/engine.rb', __dir__)

after_initialize do
  # https://github.com/discourse/discourse/blob/master/lib/plugin/instance.rb
  class ::UserSerializer
    attributes :tl3_requirements_days_visited,
               :tl3_requirements_time_period,
               :tl3_requirements_met_days_visited,
               :tl3_requirements_min_days_visited_percent,
               :tl3_requirements_met_topics_replied_to,
               :tl3_requirements_num_topics_replied_to,
               :tl3_requirements_min_topics_replied_to,
               :tl3_requirements_met_topics_viewed,
               :tl3_requirements_topics_viewed,
               :tl3_requirements_min_topics_viewed,
               :tl3_requirements_met_topics_viewed_all_time,
               :tl3_requirements_topics_viewed_all_time,
               :tl3_requirements_min_topics_viewed_all_time,
               :tl3_requirements_met_posts_read,
               :tl3_requirements_posts_read,
               :tl3_requirements_min_posts_read,
               :tl3_requirements_met_posts_read_all_time,
               :tl3_requirements_posts_read_all_time,
               :tl3_requirements_min_posts_read_all_time,
               :tl3_requirements_met_flagged_posts,
               :tl3_requirements_num_flagged_posts,
               :tl3_requirements_max_flagged_posts,
               :tl3_requirements_days_visited_percent,
               :tl3_requirements_met_flagged_by_users,
               :tl3_requirements_num_flagged_by_users,
               :tl3_requirements_max_flagged_by_users,
               :tl3_requirements_met_likes_given,
               :tl3_requirements_num_likes_given,
               :tl3_requirements_min_likes_given,
               :tl3_requirements_met_likes_received,
               :tl3_requirements_num_likes_received,
               :tl3_requirements_min_likes_received,
               :tl3_requirements_met_likes_received_days,
               :tl3_requirements_num_likes_received_days,
               :tl3_requirements_min_likes_received_days,
               :tl3_requirements_met_likes_received_users,
               :tl3_requirements_num_likes_received_users,
               :tl3_requirements_min_likes_received_users,
               :tl3_requirements_met_silenced,
               :tl3_requirements_penalty_counts_silenced,
               :tl3_requirements_met_suspended,
               :tl3_requirements_penalty_counts_suspended
               
    def tl3_requirements_days_visited
      object.tl3_requirements.days_visited
    end
      
    def tl3_requirements_num_topics_replied_to
      object.tl3_requirements.num_topics_replied_to
    end
    
    def tl3_requirements_met_days_visited
      tl3_requirements_days_visited >= SiteSetting.tl3_requires_days_visited
    end
    
    def tl3_requirements_met_topics_replied_to
      tl3_requirements_num_topics_replied_to >= SiteSetting.tl3_requires_topics_replied_to
    end
    
    def tl3_requirements_time_period
      SiteSetting.tl3_time_period
    end
    
    def tl3_requirements_days_visited_percent
      100 * tl3_requirements_days_visited / tl3_requirements_time_period
    end
    
    def tl3_requirements_min_days_visited_percent
      100 * SiteSetting.tl3_requires_days_visited / tl3_requirements_time_period
    end
    
    def tl3_requirements_min_topics_replied_to
      SiteSetting.tl3_requires_topics_replied_to
    end
    
    def tl3_requirements_met_topics_viewed
      tl3_requirements_topics_viewed >= tl3_requirements_min_topics_viewed
    end
    
    def tl3_requirements_topics_viewed
      object.tl3_requirements.topics_viewed
    end
    
    def tl3_requirements_min_topics_viewed
      [
        (TrustLevel3Requirements.num_topics_in_time_period.to_i * (SiteSetting.tl3_requires_topics_viewed.to_f / 100.0)).round,
        SiteSetting.tl3_requires_topics_viewed_cap
      ].min
    end
    
    def tl3_requirements_met_topics_viewed_all_time
      tl3_requirements_topics_viewed_all_time >= tl3_requirements_min_topics_viewed_all_time
    end
    
    def tl3_requirements_min_topics_viewed_all_time
      SiteSetting.tl3_requires_topics_viewed_all_time
    end
    
    def tl3_requirements_topics_viewed_all_time
      object.tl3_requirements.topics_viewed_all_time
    end

    def tl3_requirements_met_posts_read
      tl3_requirements_posts_read >= tl3_requirements_min_posts_read
    end
    
    def tl3_requirements_posts_read
      object.tl3_requirements.posts_read
    end
    
    def tl3_requirements_min_posts_read
      [
        (TrustLevel3Requirements.num_posts_in_time_period.to_i * (SiteSetting.tl3_requires_posts_read.to_f / 100.0)).round,
        SiteSetting.tl3_requires_posts_read_cap
      ].min
    end

    def tl3_requirements_met_posts_read_all_time
      tl3_requirements_posts_read_all_time >= tl3_requirements_min_posts_read_all_time
    end
    
    def tl3_requirements_posts_read_all_time
      object.tl3_requirements.posts_read_all_time
    end
    
    def tl3_requirements_min_posts_read_all_time
      SiteSetting.tl3_requires_posts_read_all_time
    end
    
    def tl3_requirements_met_flagged_posts
      tl3_requirements_num_flagged_posts <= tl3_requirements_max_flagged_posts
    end
    
    def tl3_requirements_num_flagged_posts
      object.tl3_requirements.num_flagged_posts
    end
    
    def tl3_requirements_max_flagged_posts
      SiteSetting.tl3_requires_max_flagged
    end
   
   
    def tl3_requirements_met_flagged_by_users
      tl3_requirements_num_flagged_by_users <= tl3_requirements_max_flagged_by_users
    end
    
    def tl3_requirements_num_flagged_by_users
      object.tl3_requirements.num_flagged_by_users
    end
    
    def tl3_requirements_max_flagged_by_users
      SiteSetting.tl3_requires_max_flagged
    end
   
    def tl3_requirements_met_likes_given
      tl3_requirements_num_likes_given >= tl3_requirements_min_likes_given
    end
    
    def tl3_requirements_num_likes_given
      object.tl3_requirements.num_likes_given
    end
    
    def tl3_requirements_min_likes_given
      SiteSetting.tl3_requires_likes_given
    end

    def tl3_requirements_met_likes_received
      tl3_requirements_num_likes_received >= tl3_requirements_min_likes_received
    end
    
    def tl3_requirements_num_likes_received
      object.tl3_requirements.num_likes_received
    end
    
    def tl3_requirements_min_likes_received
      SiteSetting.tl3_requires_likes_received
    end
    

    def tl3_requirements_met_likes_received_days
      tl3_requirements_num_likes_received_days >= tl3_requirements_min_likes_received_days
    end
    
    def tl3_requirements_num_likes_received_days
      object.tl3_requirements.num_likes_received_days
    end
    
    def tl3_requirements_min_likes_received_days
      object.tl3_requirements.min_likes_received_days
    end
      
    def tl3_requirements_met_likes_received_users
      tl3_requirements_num_likes_received_users >= tl3_requirements_min_likes_received_users
    end
    
    def tl3_requirements_num_likes_received_users
      object.tl3_requirements.num_likes_received_users
    end
    
    def tl3_requirements_min_likes_received_users
      object.tl3_requirements.min_likes_received_users
    end
    
    def tl3_requirements_met_silenced
      !object.silenced?
    end
    
    def tl3_requirements_penalty_counts_silenced
      object.tl3_requirements.penalty_counts.silenced
    end
    
    def tl3_requirements_met_suspended
      !object.suspended?
    end
    
    def tl3_requirements_penalty_counts_suspended
      object.tl3_requirements.penalty_counts.suspended
    end
  end
end
