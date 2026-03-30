create table character (
    id serial primary key,
    name varchar(255) not null
)

create table equipment (
    id serial primary key,
    character_id integer not null references character(id)
)

create table weapon (
    id serial primary key,
    equipment_id integer not null references equipment(id),
    name varchar(255) not null,
    attack_power integer not null,
    appearance varchar(255) not null,
    rarity varchar(50) not null,
    worth integer not null
)

create table helmet (
    id serial primary key,
    equipment_id integer not null references equipment(id),
    name varchar(255) not null,
    defense integer not null,
    appearance varchar(255) not null,
    rarity varchar(50) not null,
    worth integer not null
)

create table chestplate (
    id serial primary key,
    equipment_id integer not null references equipment(id),
    name varchar(255) not null,
    defense integer not null,
    appearance varchar(255) not null,
    rarity varchar(50) not null,
    worth integer not null
)

create table legpiece (
    id serial primary key,
    equipment_id integer not null references equipment(id),
    name varchar(255) not null,
    defense integer not null,
    appearance varchar(255) not null,
    rarity varchar(50) not null,
    worth integer not null
)

create table armpiece (
    id serial primary key,
    equipment_id integer not null references equipment(id),
    name varchar(255) not null,
    defense integer not null,
    appearance varchar(255) not null,
    rarity varchar(50) not null,
    worth integer not null
)

create table cape (
    id serial primary key,
    equipment_id integer not null references equipment(id),
    name varchar(255) not null,
    defense integer not null,
    appearance varchar(255) not null,
    rarity varchar(50) not null,
    worth integer not null
)

