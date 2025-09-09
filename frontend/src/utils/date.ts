import dayjs from "dayjs";

export function parseAppointmentDate(date: Date, time: string) {
  const [hour, minutes] = time.split(":");
  return dayjs(date)
    .set("hour", Number(hour))
    .set("minute", Number(minutes))
    .format("YYYY-MM-DDTHH:mm:ss");
}
