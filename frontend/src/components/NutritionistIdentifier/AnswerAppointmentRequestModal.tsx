import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { useAcceptAppointment, useRejectAppointment } from "@/services/appointments/mutations";
import dayjs from "dayjs";
import { useState } from "react";

interface AnswerAppointmentRequestModalProps {
  children: React.ReactNode;
  appointmentId: string;
  nutritionistId: string;
  startsAt: string;
  guest: string;
}

export function AnswerAppointmentRequestModal(props: AnswerAppointmentRequestModalProps) {
  const { children, appointmentId, nutritionistId, startsAt, guest } = props;

  const [open, setOpen] = useState(false);

  const acceptAppointmentMutation = useAcceptAppointment();
  const rejectAppointmentMutation = useRejectAppointment();

  const handleCloseModal = () => {
    setOpen(false);
  };

  const handleAcceptAppointment = async () => {
    await acceptAppointmentMutation.mutateAsync({ appointmentId, nutritionistId });
    handleCloseModal();
  };

  const handleRejectAppointment = async () => {
    await rejectAppointmentMutation.mutateAsync({ appointmentId, nutritionistId });
    handleCloseModal();
  };
  
  const appointmentDate = dayjs(startsAt).format("DD MMMM YYYY");
  const appointmentHour = dayjs(startsAt).format("HH:mm");

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>{children}</DialogTrigger>
      <DialogContent className="sm:max-w-md">
        <DialogHeader className="pb-2">
          <DialogTitle>Answer appointment request</DialogTitle>
        </DialogHeader>
        <div>
          Would you like to accept or reject {guest}'s appointment request for {appointmentDate} at{" "}
          {appointmentHour}?
        </div>
        <DialogFooter>
          <Button variant="destructive" onClick={handleRejectAppointment}>
            Reject
          </Button>
          <Button onClick={handleAcceptAppointment}>Accept</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
