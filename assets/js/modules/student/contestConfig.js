export const TEST_STRUCTURE = {
  tf: 10,
  abc_one: 10,
  match: 1,
  abc_multi: 3,
};

export const TYPE_ORDER = ["tf", "abc_one", "match", "abc_multi"];

export const POINTS = {
  tf: 2,
  abc_one: 4,
  abc_multi: 5,
  matchPair: 2,
  matchMax: 10,
};

export const OFFICIAL_BONUS_POINTS = 15;
const LEGACY_MAX_POINTS = 85;

export const ATTEMPTS_TABLE = "student_test_attempts";

export function getTestMaxPoints(assumedMatchPairs = 5) {
  return (
    TEST_STRUCTURE.tf * POINTS.tf
    + TEST_STRUCTURE.abc_one * POINTS.abc_one
    + TEST_STRUCTURE.abc_multi * POINTS.abc_multi
    + Math.min(assumedMatchPairs, 5) * POINTS.matchPair
    + OFFICIAL_BONUS_POINTS
  );
}

function shouldApplyLegacyBonus(row) {
  const maxPoints = Number(row?.max_points || 0);
  return maxPoints > 0 && maxPoints <= LEGACY_MAX_POINTS;
}

export function getEffectivePoints(row) {
  const points = Number(row?.points_total || 0);
  return shouldApplyLegacyBonus(row) ? points + OFFICIAL_BONUS_POINTS : points;
}

export function getEffectiveMaxPoints(row) {
  const maxPoints = Number(row?.max_points || 0);
  return shouldApplyLegacyBonus(row) ? maxPoints + OFFICIAL_BONUS_POINTS : maxPoints;
}

export function getStartOfWeekISO(now = new Date()) {
  const d = new Date(now);
  const day = d.getDay();
  const diffToMonday = (day + 6) % 7;
  d.setDate(d.getDate() - diffToMonday);
  d.setHours(0, 0, 0, 0);
  return d.toISOString();
}

export function getStartOfMonthISO(now = new Date()) {
  const d = new Date(now.getFullYear(), now.getMonth(), 1, 0, 0, 0, 0);
  return d.toISOString();
}

export function aggregateLeaderboard(rows) {
  const map = new Map();

  rows.forEach((row) => {
    const user = row.student_username || "necunoscut";
    const current = map.get(user) || { student_username: user, points: 0, tests: 0 };
    current.points += getEffectivePoints(row);
    current.tests += 1;
    map.set(user, current);
  });

  return Array.from(map.values()).sort((a, b) => {
    if (b.points !== a.points) return b.points - a.points;
    return b.tests - a.tests;
  });
}
