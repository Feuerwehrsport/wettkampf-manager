FactoryGirl.define do
  factory :team do
    name "Mecklenburg-Vorpommern"
    gender :male

    trait(:male) { gender :male }
    trait(:female) { gender :female }
  end

  factory :person do
    first_name "Alfred"
    last_name "Meier"
    gender :male

    trait(:male) { gender :male }
    trait(:female) { gender :female }
    trait(:with_team) do
      team { Team.first || build(:team) }
    end
  end

  factory :climbing_hook_ladder, class: "Disciplines::ClimbingHookLadder" do
  end

  factory :assessment do
    discipline { Disciplines::ClimbingHookLadder.first || create(:climbing_hook_ladder) }
    name "Hakenleitersteigen - männlich"
    gender :male
  end

  factory :score_list, class: "Score::List" do
    assessment { Assessment.first || build(:assessment) }
    name "Lauf 1"
  end  

  factory :score_list_entry, class: "Score::ListEntry" do
    track 1
    run 1
    entity { Person.first || build(:person) }    
  end
end