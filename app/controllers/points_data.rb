module PointsData
  POINT_TYPE_FOR_WEIGHT = {
    0 => 'stone',
    1 => 'wood',
    2 => 'iron',
    3 => 'bronze',
    4 => 'silver',
    5 => 'gold',
    6 => 'platinum',
    7 => 'pearl',
    8 => 'ruby',
    9 => 'emerald',
    10 => 'diamond'
  }
  MAX_WEIGHT = 10
  MINUTES_EQUIVALENT_FOR_WEIGHT = {
    0 => 1,
    1 => 2,
    2 => 4,
    3 => 8,
    4 => 15,
    5 => 30,
    6 => 60,
    7 => 120,
    8 => 240,
    9 => 500,
    10 => 1000,
    11 => 2000,
    12 => 4000
  }
  TIME_EQUIVALENT_FOR_WEIGHT = {
    0 => 'one minute',
    1 => 'two minutes',
    2 => 'four minutes',
    3 => 'eight minutes', 
    4 => 'a quarter hour',
    5 => 'a half hour',
    6 => 'an hour',
    7 => 'two hours',
    8 => 'four hours',
    9 => 'eight hours',
    10 => 'twice eight hours',
    11 => 'four times eight hours'
  }
  TIME_FOR_URGENCY = {
    10 => 'ten seconds',
    9 => 'half a minute',
    8 => 'two minutes',
    7 => 'five minutes',
    6 => 'a quarter hour',
    5 => 'an hour',
    4 => 'three hours',
    3 => 'ten hours',
    2 => 'over a day',
    1 => 'four days',
    0 => 'twelve days'
  }
  SHORTER_TIME_FOR_URGENCY = {
    10 => '10s',
    9 => '30s',
    8 => '2m',
    7 => '5m',
    6 => '15m',
    5 => '1h',
    4 => '3h',
    3 => '10h',
    2 => '>1d',
    1 => '4d',
    0 => '12d'
  }
end