require 'test_helper'


class UtilityTest < ActiveSupport::TestCase

  include Utility
  include Nutrients
  include Goals

  STRAWBERRIES_NDBNO = '09316'
  TURKEY_NDBNO = "05200"
  BOGUS_NDBNO = 818181818181818
  FIREWEED_LOCAL_RAW_HONEY = 45104569

  BIGMAC_NDBNO='21350'
  POTATO_RUSSET_NDBNO ='11674'


  test 'correctly handle bogus nutrient on valid food' do
    result = nutrient_per_measure('Kryptonite', STRAWBERRIES_NDBNO, 'g', 1.0)
    assert_equal NOT_AVAILABLE, result
  end

  test 'correctly handle bogus food and valid food ' do
    result = nutrient_per_measure(CHOLE, BOGUS_NDBNO, 'g', 1.0)
    assert_equal NOT_AVAILABLE, result
  end

  test 'correctly handle bogus measure' do
    result = nutrient_per_measure(ENERC_KCAL, STRAWBERRIES_NDBNO, 'foobar', 3.0)
    assert_equal NOT_AVAILABLE, result
  end

  test 'correctly handle valid query' do
    result = nutrient_per_measure(CHOLE, STRAWBERRIES_NDBNO, 'g', 1.0)
    assert_equal 0.00, result
  end

  test 'nutrient_per_measure with known flawed record' do
    expected = 'N/A'
    actual = nutrient_per_measure(Nutrients::WATER,
                                  FIREWEED_LOCAL_RAW_HONEY,
                                  'g',
                                  1.0)
    assert_equal expected, actual
  end

  test 'correctly handle second valid query' do
    result = nutrient_per_measure(ENERC_KCAL, STRAWBERRIES_NDBNO,
                                  'cup, pureed', 1.0)
    assert_equal 74.0, result
  end

  test 'correctly handle grams Energy query' do
    result = nutrient_per_measure(ENERC_KCAL, STRAWBERRIES_NDBNO, 'g', 453.6)
    assert_equal 145, result.to_i
  end

  test 'correctly handle grams potassium query' do
    result = nutrient_per_measure(K, STRAWBERRIES_NDBNO, 'g', 453.6)
    assert_equal 694, result.to_i
  end

  test 'correctly handle nutrient qty attribute' do
    result = nutrient_per_measure(CHOLE, TURKEY_NDBNO, "oz", 1)
    assert_equal 29, result.to_i
  end

  test 'determine eqv weight in grams of food serving ' do
    squash_winter_butternut_cooked_baked_without_salt = 11486
    measure = "cup, cubes"

    expected = 205
    actual = gram_equivelent(squash_winter_butternut_cooked_baked_without_salt,
                             measure)

    assert_equal expected, actual
  end

  test 'determine eqv weight in grams of potato' do
    potato_baked_russet = 11356
    measure = "potato large (3\" to 4-1\/4\" dia."
    expected = 299
    actual = gram_equivelent(potato_baked_russet, measure)
    assert_equal expected, actual
  end

  test 'determine eqv weight in grams, varying qty parameters' do
    turkey = '05200'
    measure = 'oz'
    expected = 28
    actual = gram_equivelent(turkey, measure).to_i
    assert_equal expected, actual
  end

  test 'correct operation of gram_equivelent when measure is "g"' do
    measure = 'g'
    expected = 1.0
    actual = gram_equivelent(STRAWBERRIES_NDBNO, measure).to_i
    assert_equal expected, actual
  end

  test 'another test, varying qty parameters' do
    turkey = '05200'
    measure = 'turkey, bone removed'
    expected = 808*2
    actual = gram_equivelent(turkey, measure).to_i
    assert_equal expected, actual
  end

  test 'energy density of strawberries' do
    expected = 145
    actual = energy_density(STRAWBERRIES_NDBNO).to_i
    assert_equal expected, actual
  end

  test 'energy density of dry kasha is' do
    expected = 1569
    dry_kasha_ndbno = 20009
    actual = energy_density(dry_kasha_ndbno).to_i
    assert_equal expected, actual
  end

  test 'correctly finds the general factor from a multi-ingredient food ' do
    expected = CALORIES_PER_GRAM_CARB
    actual = calories_per_gram(BIGMAC_NDBNO, 'cf', CALORIES_PER_GRAM_CARB)
    assert_equal expected, actual
  end

  test 'correctly finds the specific factor from a whole natural food' do
    expected = 2.78
    actual = calories_per_gram(POTATO_RUSSET_NDBNO, 'pf',
                               CALORIES_PER_GRAM_PROTEIN)
    assert_equal expected, actual
  end


  end

end
