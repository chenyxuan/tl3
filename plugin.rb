# frozen_string_literal: true

# name: tl3
# about: show tl3 requirements to users
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
  class ::UsersController
    module OverridingShow
      def show(for_card: false)
        return redirect_to path('/login') if SiteSetting.hide_user_profiles_from_public && !current_user

        @user = fetch_user_from_params(
          include_inactive: current_user.try(:staff?) || (current_user && SiteSetting.show_inactive_accounts)
        )

        user_serializer = nil
        if guardian.can_see_profile?(@user)
          serializer_class = for_card ? UserCardSerializer : UserSerializer
          user_serializer = serializer_class.new(@user, scope: guardian, root: 'user')
          user_tl3_serializer = for_card ? nil : TrustLevel3RequirementsSerializer.new(@user.tl3_requirements)
          
          topic_id = params[:include_post_count_for].to_i
          if topic_id != 0
            user_serializer.topic_post_count = { topic_id => Post.secured(guardian).where(topic_id: topic_id, user_id: @user.id).count }
          end
        else
          user_serializer = HiddenProfileSerializer.new(@user, scope: guardian, root: 'user')
        end

        if !params[:skip_track_visit] && (@user != current_user)
          track_visit_to_user_profile
        end

        # This is a hack to get around a Rails issue where values with periods aren't handled correctly
        # when used as part of a route.
        if params[:external_id] && params[:external_id].ends_with?('.json')
          return render_json_dump(user_serializer)
        end

        respond_to do |format|
          format.html do
            logFile = File.new("tl3.log", "a")
            logFile.syswrite("html\n")
            logFile.close
            @restrict_fields = guardian.restrict_user_fields?(@user)
            store_preloaded("user_#{@user.username}", MultiJson.dump(user_serializer))
          end

          format.json do
            logFile = File.new("tl3.log", "a")
            logFile.syswrite("json\n")
            logFile.close
            if user_tl3_serializer.nil?
              render_json_dump(user_serializer)
            else
              user_json = MultiJson.dump(user_serializer)
              user_tl3_json = MultiJson.dump(user_tl3_serializer)
              user_hash = MultiJson.load(user_json)
              user_tl3_hash = MultiJson.load(user_tl3_json)
              user_hash["user"] = user_hash["user"].merge(user_tl3_hash)
              render json: MultiJson.dump(user_hash)
              logFile = File.new("tl3.log", "a")
              logFile.syswrite("#{MultiJson.dump(user_hash)}\n")
              logFile.close
            end
          end
        end
      end
    end
    
    prepend OverridingShow
    
  end
end
