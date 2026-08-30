import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { renderHook, waitFor } from "@testing-library/react";
import type { ReactNode } from "react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { useAcceptAppointment } from "../mutations";

const { toastError, toastSuccess } = vi.hoisted(() => ({
  toastError: vi.fn(),
  toastSuccess: vi.fn(),
}));

vi.mock("@/utils/toasts", () => ({ toastError, toastSuccess }));

function wrapper({ children }: { children: ReactNode }) {
  const queryClient = new QueryClient({
    defaultOptions: { queries: { retry: false }, mutations: { retry: false } },
  });

  return <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>;
}

function respondWith(status: number, body: unknown) {
  vi.stubGlobal(
    "fetch",
    vi.fn().mockResolvedValue({
      ok: status >= 200 && status < 300,
      status,
      json: async () => body,
    }),
  );
}

const PARAMS = {
  appointmentId: "3f1a0f4e-0000-4000-8000-000000000001",
  nutritionistId: "3f1a0f4e-0000-4000-8000-000000000002",
};

describe("useAcceptAppointment", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("surfaces the conflict when the slot was taken by another acceptance", async () => {
    respondWith(409, [{ message: "This time slot is no longer available" }]);

    const { result } = renderHook(() => useAcceptAppointment(), { wrapper });

    await expect(result.current.mutateAsync(PARAMS)).rejects.toThrow(
      "This time slot is no longer available",
    );

    await waitFor(() => {
      expect(toastError).toHaveBeenCalledWith("This time slot is no longer available");
    });
    expect(toastSuccess).not.toHaveBeenCalled();
  });

  it("does not report a failed request as a success", async () => {
    respondWith(404, [{ message: "Couldn't find Appointment" }]);

    const { result } = renderHook(() => useAcceptAppointment(), { wrapper });

    await expect(result.current.mutateAsync(PARAMS)).rejects.toThrow();
    expect(toastSuccess).not.toHaveBeenCalled();
  });

  it("reports a real acceptance as a success", async () => {
    respondWith(200, { message: "Appointment accepted" });

    const { result } = renderHook(() => useAcceptAppointment(), { wrapper });

    await result.current.mutateAsync(PARAMS);

    await waitFor(() => {
      expect(toastSuccess).toHaveBeenCalledWith("Appointment accepted");
    });
    expect(toastError).not.toHaveBeenCalled();
  });
});
