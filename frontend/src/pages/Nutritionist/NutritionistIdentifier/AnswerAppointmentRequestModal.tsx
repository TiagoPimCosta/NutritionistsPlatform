import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import dayjs from "dayjs";

interface AnswerAppointmentRequestModalProps {
  children: React.ReactNode;
  date: string;
  guest: string;
}

export function AnswerAppointmentRequestModal(props: AnswerAppointmentRequestModalProps) {
  const { children, date, guest } = props;

  const handleRejectAppointment = () => {
    console.log("Reject Appointment");
  };

  const handleAcceptAppointment = () => {
    console.log("Accept Appointment");
  };

  return (
    <Dialog>
      <DialogTrigger asChild>{children}</DialogTrigger>
      <DialogContent className="sm:max-w-md">
        <DialogHeader className="pb-2">
          <DialogTitle>Answer appointment request</DialogTitle>
        </DialogHeader>
        <div>
          Would you like to accept or reject {guest}'s appointment request for{" "}
          {dayjs(date).format("DD MMMM YYYY")} at {dayjs(date).format("HH:mm a")}?
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
