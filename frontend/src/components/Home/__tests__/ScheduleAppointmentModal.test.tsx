import { screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { ScheduleAppointmentModal } from "../ScheduleAppointmentModal";
import { renderWithProviders } from "@/test/renderWithProviders";

const { createAppointment } = vi.hoisted(() => ({
  createAppointment: vi.fn(),
}));

vi.mock("@/services/appointments/mutations", () => ({
  useCreateAppointment: () => ({ mutateAsync: createAppointment }),
}));

const OFFERING_ID = "3f1a0f4e-0000-4000-8000-000000000001";

async function openForm() {
  const user = userEvent.setup();

  renderWithProviders(
    <ScheduleAppointmentModal nutritionistServiceId={OFFERING_ID}>
      <button type="button">Open scheduling form</button>
    </ScheduleAppointmentModal>,
  );

  await user.click(
    screen.getByRole("button", { name: "Open scheduling form" }),
  );
  return user;
}

describe("ScheduleAppointmentModal", () => {
  beforeEach(() => {
    createAppointment.mockReset();
    createAppointment.mockResolvedValue({ message: "Appointment created" });
  });

  it("refuses to submit an empty form and says what is missing", async () => {
    const user = await openForm();

    await user.click(screen.getByRole("button", { name: "Save changes" }));

    expect(await screen.findByText("Name is required")).toBeInTheDocument();
    expect(screen.getByText("Enter a valid email")).toBeInTheDocument();
    expect(screen.getByText("Date and time are required")).toBeInTheDocument();
    expect(createAppointment).not.toHaveBeenCalled();
  });

  it("submits the offering id and the chosen start time", async () => {
    const user = await openForm();

    await user.type(screen.getByPlaceholderText("Name"), "Ana Martins");
    await user.type(screen.getByPlaceholderText("Email"), "ana@example.com");
    await user.click(screen.getByLabelText("Date"));

    await user.click(
      await screen.findByRole("button", { name: /15th, \d{4}$/ }),
    );
    await user.type(screen.getByLabelText("Time"), "14:30");
    await user.click(screen.getByRole("button", { name: "Save changes" }));

    await waitFor(() => expect(createAppointment).toHaveBeenCalledTimes(1));

    const payload = createAppointment.mock.calls[0][0];
    expect(payload.nutritionist_service_id).toBe(OFFERING_ID);
    expect(payload.name).toBe("Ana Martins");
    expect(payload.email).toBe("ana@example.com");
    expect(payload.starts_at).toMatch(/T14:30:00$/);
    expect(payload).not.toHaveProperty("nutritionist_id");
    expect(payload).not.toHaveProperty("date");
  });
});
