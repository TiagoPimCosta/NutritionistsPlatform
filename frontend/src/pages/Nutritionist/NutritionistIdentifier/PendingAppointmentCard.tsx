import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Calendar, Clock } from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import dayjs from "dayjs";
import { Button } from "@/components/ui/button";
import { AnswerAppointmentRequestModal } from "./AnswerAppointmentRequestModal";
import type { NutritionistPendingAppointmentsObj } from "@/services/nutritionists/queries";

interface PendingAppointmentCard {
  appointment: NutritionistPendingAppointmentsObj;
}

const PendingAppointmentCard = (props: PendingAppointmentCard) => {
  const { appointment } = props;
  const { id, date, guest, nutritionist_id } = appointment;

  const nameInitials = guest.name
    .split(" ")
    .map((n) => n[0])
    .join("");

  const appointmentDate = dayjs(date).format("DD MMMM YYYY");
  const appointmentHour = dayjs(date).format("HH:mm a");

  return (
    <Card className=" shadow-md hover:shadow-lg transition-shadow pb-0">
      <CardContent className="px-6">
        <div className="flex gap-8">
          <Avatar className="h-20 w-20">
            <AvatarImage src="/public/avatar-icon.png" alt={guest.name} />
            <AvatarFallback className="bg-primary/10 text-primary font-semibold">
              {nameInitials}
            </AvatarFallback>
          </Avatar>
          <div className="flex-1">
            <div className="flex flex-col gap-4 w-full justify-between">
              <div className="flex flex-col">
                <h3 className="text-2xl mb-1">{guest.name}</h3>
                <span className="text-sm text-muted-foreground">Online appointment</span>
              </div>

              <div className="flex flex-col gap-2">
                <div className="flex flex-col gap-2">
                  <span className="flex flex-row gap-2 text-sm text-muted-foreground items-center">
                    <Calendar className="h-4 w-4 text-primary" />
                    {appointmentDate}
                  </span>
                  <span className="flex flex-row gap-2 text-sm text-muted-foreground items-center">
                    <Clock className="h-4 w-4 text-primary" />
                    {appointmentHour}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </CardContent>
      <CardFooter className="border-t p-0 pt-0">
        <AnswerAppointmentRequestModal
          date={date}
          guest={guest.name}
          appointmentId={id}
          nutritionistId={nutritionist_id}
        >
          <Button variant="anwserRequest" className="w-full rounded-t-none rounded-b-xl font-bold">
            Answer Request
          </Button>
        </AnswerAppointmentRequestModal>
      </CardFooter>
    </Card>
  );
};

export default PendingAppointmentCard;
