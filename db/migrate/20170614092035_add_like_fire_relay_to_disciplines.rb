class AddLikeFireRelayToDisciplines < ActiveRecord::Migration[4.2]
  def change
    add_column :disciplines, :like_fire_relay, :boolean, default: false, null: false
    Disciplines::FireRelay.update_all(like_fire_relay: true)
  end
end
