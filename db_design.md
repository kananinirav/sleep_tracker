# DB Design

## Tables

- User
- Sleep Tracking
- User Friendship

### User

| Column     | Data Type  | Primary Key | Foreign key | Default Value | Comment |
| ---------- | ---------- | ----------- | ----------- | ------------- | ------- |
| id         | Integer    | ○           |             |               |         |
| user_name  | String     |             |             |               |         |
| created_at | Time Stamp |             |             |               |         |
| updated_at | Time Stamp |             |             |               |         |

### Sleep Tracking

| Column         | Data Type  | Primary Key | Foreign key | Default Value | Comment               |
| -------------- | ---------- | ----------- | ----------- | ------------- | --------------------- |
| id             | Integer    | ○           |             |               |                       |
| user_id        | Integer    |             | ○           |               | user table references |
| clock_in       | Date Time |             |             |               |                       |
| clock_out      | Date Time |             |             |               |                       |
| sleep_duration | Integer    |             |             |               | In seconds            |
| created_at     | Time Stamp |             |             |               |                       |
| updated_at     | Time Stamp |             |             |               |                       |

### User Friendship

| Column            | Data Type  | Primary Key | Foreign key | Default Value | Comment               |
| ----------------- | ---------- | ----------- | ----------- | ------------- | --------------------- |
| id                | Integer    | ○           |             |               |                       |
| follower_user_id  | Integer    |             | ○           |               | user table references |
| following_user_id | Integer    |             | ○           |               | user table references |
| created_at        | Time Stamp |             |             |               |                       |
| updated_at        | Time Stamp |             |             |               |                       |

To speed up performance we will create clustered index for ( follower_user_id, following_user_id)
