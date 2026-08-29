import { describe, expect, it } from "vitest";
import { parseAppointmentDate } from "../date";

describe("parseAppointmentDate", () => {
  it("combines the chosen day with the chosen time", () => {
    const day = new Date(2026, 8, 15);

    expect(parseAppointmentDate(day, "14:30")).toBe("2026-09-15T14:30:00");
  });

  it("sends no timezone marker, so the server reads the wall clock time the guest picked", () => {
    const day = new Date(2026, 8, 15);

    expect(parseAppointmentDate(day, "09:05")).not.toMatch(/Z|[+-]\d{2}:\d{2}$/);
  });
});
