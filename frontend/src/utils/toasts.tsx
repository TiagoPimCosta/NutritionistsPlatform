import { CircleCheck, CircleX } from "lucide-react";
import { toast } from "react-toastify";

const AUTO_CLOSE_TIMER = 3000;

export function toastSuccess(message: string) {
  return toast.success(message, {
    icon: <CircleCheck className="text-success" />,
    autoClose: AUTO_CLOSE_TIMER,
  });
}

export function toastError(message: string) {
  return toast.error(message, {
    icon: <CircleX className="text-danger" />,
    autoClose: AUTO_CLOSE_TIMER,
  });
}
