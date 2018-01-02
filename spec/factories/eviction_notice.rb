FactoryBot.define do
  factory :eviction_notice do
    sequence(:eviction_id) { |n| "eviction_id_#{n}"}
    sequence(:address) { |n| "#{n} Hayes St"}
    city "San Francisco"
    state "CA"
    file_date Date.today

    non_payment false
    breach false
    nuisance false
    illegal_use false
    failure_to_sign_renewal false
    access_denial false
    unapproved_subtenant false
    owner_move_in false
    demolition false
    capital_improvement false
    substantial_rehab false
    ellis_act_withdrawal false
    condo_conversion false
    roommate_same_unit false
    other_cause false
    late_payments false
    lead_remediation false
    development false
    good_samaritan_ends true
  end
end
