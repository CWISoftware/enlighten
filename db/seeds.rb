puts
puts 'Creating administrator permission role...'
permission_role_administrator = FactoryGirl.create(:permission_role, :administrator)

puts
puts 'Creating administrator permission role acls...'
permission_acls_administrator = {
  dashboard: [
    :index
  ],
  activity: [
    :create
  ],
  client: [
    :index, :cards, :show, :card, :new, :edit, :create, :update, :destroy, :unfollow, :follow, :unlike, :like
  ],
  dashboard: [
    :index
  ],
  person: [
    :index, :cards, :show, :card, :new, :edit, :create, :update, :destroy, :unfollow, :follow, :unlike, :like
  ],
  post: [
    :new, :create
  ],
  project: [
    :index, :cards, :show, :card, :new, :edit, :create, :update, :destroy, :unfollow, :follow, :unlike, :like
  ],
  technology: [
    :index, :cards, :show, :card, :new, :edit, :create, :update, :destroy, :unfollow, :follow, :unlike, :like
  ],
  card: [
    :index, :cards, :card, :unfollow, :follow, :unlike, :like
  ]
}

permission_acls_administrator.each do|model, actions|
  puts "Inserting acls to #{model.to_s}:"
  actions.each do |action|
    puts "- #{action.to_s} \n"
    FactoryGirl.create :permission_acl, model: model.to_s, action: action.to_s, permission_role_id: permission_role_administrator.id
  end
end

puts
puts 'Creating user permission role...'
permission_role_user = FactoryGirl.create(:permission_role, :user, default: true)

puts
puts 'Creating user permission role acls...'
permission_acls_user = {
  dashboard: [
    :index
  ],
  activity: [
    :create
  ],
  client: [
    :index, :cards, :show, :card, :unfollow, :follow, :unlike, :like
  ],
  dashboard: [
    :index
  ],
  person: [
    :index, :cards, :show, :card, :unfollow, :follow, :unlike, :like
  ],
  post: [
    :new, :create
  ],
  project: [
    :index, :cards, :show, :card, :unfollow, :follow, :unlike, :like
  ],
  technology: [
    :index, :cards, :show, :card, :unfollow, :follow, :unlike, :like
  ],
  card: [
    :index, :cards, :card, :unfollow, :follow, :unlike, :like
  ]
}

permission_acls_user.each do|model, actions|
  puts "Inserting acls to #{model.to_s}:"
  actions.each do |action|
    puts "- #{action.to_s} \n"
    FactoryGirl.create :permission_acl, model: model.to_s, action: action.to_s, permission_role_id: permission_role_user.id
  end
end
