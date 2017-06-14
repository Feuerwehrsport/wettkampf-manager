class AddLikeFireRelayToDisciplines < ActiveRecord::Migration
  def change
    add_column :disciplines, :like_fire_relay, :boolean, default: false, null: false
    Disciplines::FireRelay.update_all(like_fire_relay: true)
  end
end
