create table character (
    id serial primary key,
    name varchar(255) not null
    age integer not null
)

create table equipment (
    id serial primary key,
    character_id integer not null references character(id),
    piece varchar(255) not null
    name varchar(255) not null
    stat integer not null
    rarity varchar(50) not null
    worth integer not null
    description text not null
)

