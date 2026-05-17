# Trekking Booking System - SQL Project

This is a database project I built to practice SQL. The idea behind it is a trekking booking application where users can register, browse trails at various destinations, and make bookings. It covers table design, relationships, and a range of queries from simple lookups to aggregations and subqueries.

---

## Database Schema

The database has four core tables:

**User** - Stores registered users with their contact details and role (User or Admin).

**Destination** - Stores trekking destinations with location details like state, city, and zip code.

**Trail** - Stores individual trails linked to a destination. Each trail has a difficulty level, duration, total available slots, date, and time slot.

**Booking** - Links a user to a trail. Records how many people are going, the date, and the time slot booked.

### Relationships

- Each Trail belongs to one Destination (via `FK_Dest_ID`)
- Each Booking belongs to one User (via `FK_User_ID`) and one Trail (via `FK_Trail_ID`)

---

## Queries Covered

### Admin Queries

**Total trails per destination** - Counts how many trails exist at each destination, ordered by the highest count first. Uses `JOIN`, `GROUP BY`, and `ORDER BY`.

**Total bookings and headcount for a specific time and place** - Finds total people and booking count for the 8 AM trek in Arizona on November 27th. Uses multiple `JOIN`s with `SUM` and `COUNT` aggregations.

**Trails with a rating below 3** - Pulls trail details alongside low review ratings. Joins the Trail table with a Review table on `FK_Trail_ID`.

### User Queries

**View all bookings in a given month** - Filters a specific user's bookings by month using `LIKE` on the date field.

**Find easy, short trails on weekends in California** - Filters trails by state, difficulty level, duration format, and weekend dates. Good example of combining multiple `WHERE` conditions.

**Check available slots at a destination** - Calculates remaining slots by subtracting booked people from total slots. Uses `SUM` with `GROUP BY` and orders results by availability.

**Users with more than one booking** - Uses a subquery with `HAVING COUNT > 1` to find repeat users, then pulls their full booking details.

### Full User Flow (Registration to Booking)

A step-by-step walkthrough showing how the queries connect in a real use case:

1. A new user registers and is inserted into the User table
2. The user searches for available trails in Sedona
3. The user checks the cost for 3 people on a specific trail
4. The booking is inserted into the Booking table
5. The user views their full booking details across all four tables

### Visualization Query

A summary query that aggregates bookings by trail and destination, intended to feed into a chart or dashboard. Shows total people per trail sorted in descending order.

---

## What I Learned

- Designing normalized tables with primary and foreign keys
- Writing multi-table JOINs (inner joins across three and four tables)
- Using aggregation functions like `COUNT`, `SUM`, and `HAVING`
- Filtering with `LIKE` for partial string matches (useful for date strings stored as text)
- Writing subqueries inside a `WHERE IN` clause
- Thinking through a realistic end-to-end user flow in SQL

---

## Notes

- Dates are stored as `VARCHAR` (e.g., `'Friday, November 25, 2022'`). A real production system would use a proper `DATE` type, but this format worked for the project scope.
- Only one sample insert per table is shown in the script. The full dataset had more rows to support all the queries.
- The Review table referenced in Query 7 is not defined in this script. It was part of the broader database used during the project.

---

## Tools Used

- MySQL
- MySQL Workbench
