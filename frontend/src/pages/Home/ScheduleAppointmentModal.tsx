import { Button } from "@/components/ui/button";
import { Calendar } from "@/components/ui/calendar";
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { cn } from "@/lib/utils";
import dayjs from "dayjs";
import { ChevronDownIcon } from "lucide-react";
import { useState } from "react";

interface ScheduleAppointmentModalProps {
  children: React.ReactNode;
  nutritionistId: string;
}

export function ScheduleAppointmentModal(props: ScheduleAppointmentModalProps) {
  const { children } = props;

  const [open, setOpen] = useState(false);
  const [date, setDate] = useState<Date | undefined>(undefined);

  const handleSubmitScheduleAppointment = () => {
    console.log("Teste");
  };

  return (
    <Dialog>
      <DialogTrigger asChild>{children}</DialogTrigger>
      <DialogContent className="sm:max-w-md">
        <DialogHeader className="pb-4">
          <DialogTitle>Schedule appointment</DialogTitle>
        </DialogHeader>
        <div className="flex flex-col gap-4">
          <div className="flex flex-col gap-2">
            <Label htmlFor="link" className="sr-only">
              Name
            </Label>
            <Input type="text" placeholder="Name" />
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="link" className="sr-only">
              Email
            </Label>
            <Input type="email" placeholder="Email" />
          </div>
        </div>
        <div className="flex gap-4">
          <div className="flex flex-col flex-1 gap-2">
            <Label htmlFor="date-picker" className="px-1 sr-only">
              Date
            </Label>
            <Popover open={open} onOpenChange={setOpen}>
              <PopoverTrigger asChild>
                <Button
                  id="date-picker"
                  className={cn(
                    "justify-between font-normal bg-input text-muted-foreground hover:bg-input",
                    date && "text-foreground"
                  )}
                >
                  {date ? dayjs(date).format("DD MMM YYYY") : "Select date"}
                  <ChevronDownIcon />
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-auto overflow-hidden p-0" align="start">
                <Calendar
                  mode="single"
                  selected={date}
                  captionLayout="dropdown"
                  onSelect={(date) => {
                    setDate(date);
                    setOpen(false);
                  }}
                />
              </PopoverContent>
            </Popover>
          </div>
          <div className="flex flex-col flex-1 gap-2">
            <Label htmlFor="time-picker" className="px-1 sr-only">
              Time
            </Label>
            <Input
              type="time"
              id="time-picker"
              step="1"
              defaultValue="10:30:00"
              className="appearance-none [&::-webkit-calendar-picker-indicator]:hidden [&::-webkit-calendar-picker-indicator]:appearance-none"
            />
          </div>
        </div>
        <DialogFooter>
          <DialogClose asChild>
            <Button variant="destructive" type="button">
              Close
            </Button>
          </DialogClose>
          <Button type="submit" onClick={handleSubmitScheduleAppointment}>
            Save changes
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
