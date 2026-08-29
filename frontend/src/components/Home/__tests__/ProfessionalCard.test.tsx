import { screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import ProfessionalCard from "../ProfessionalCard";
import { renderWithProviders } from "@/test/renderWithProviders";
import type { NutritionistsServicesObj } from "@/services/nutritionistsServices/queries";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children }: { children: React.ReactNode }) => (
    <a href="/">{children}</a>
  ),
}));

const offering: NutritionistsServicesObj = {
  id: "3f1a0f4e-0000-4000-8000-000000000001",
  nutritionist_id: "3f1a0f4e-0000-4000-8000-000000000002",
  service_id: "3f1a0f4e-0000-4000-8000-000000000003",
  created_at: "2026-08-29T10:00:00.000Z",
  updated_at: "2026-08-29T10:00:00.000Z",
  street: "Rua de Santa Catarina 450",
  city: "Porto",
  price_cents: 1490,
  duration_minutes: 45,
  nutritionist: {
    id: "3f1a0f4e-0000-4000-8000-000000000002",
    name: "Carla Santos",
    license_number: "2963N",
    title: "Nutricionista",
  },
  service: { name: "Dietético" },
};

describe("ProfessionalCard", () => {
  it("shows the professional's credentials", () => {
    renderWithProviders(<ProfessionalCard nutritionistsService={offering} />);

    expect(screen.getByText("Carla Santos")).toBeInTheDocument();
    expect(screen.getByText(/Nutricionista/)).toBeInTheDocument();
    expect(screen.getByText(/2963N/)).toBeInTheDocument();
  });

  it("shows the service and how long the appointment lasts", () => {
    renderWithProviders(<ProfessionalCard nutritionistsService={offering} />);

    expect(screen.getByText(/Dietético · 45 min/)).toBeInTheDocument();
  });

  it("formats the price from cents", () => {
    renderWithProviders(<ProfessionalCard nutritionistsService={offering} />);

    expect(screen.getByText(/14\.90/)).toBeInTheDocument();
  });

  it("shows where the appointment takes place", () => {
    renderWithProviders(<ProfessionalCard nutritionistsService={offering} />);

    expect(screen.getByText("Rua de Santa Catarina 450")).toBeInTheDocument();
    expect(screen.getByText("Porto")).toBeInTheDocument();
  });
});
