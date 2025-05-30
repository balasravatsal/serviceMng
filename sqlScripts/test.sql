PGDMP     '    1                }         
   serviceMng    15.4    15.4 g    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    24984 
   serviceMng    DATABASE     �   CREATE DATABASE "serviceMng" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "serviceMng";
                postgres    false            b           1247    25000    incident_status    TYPE     ^   CREATE TYPE public.incident_status AS ENUM (
    'Open',
    'Resolved',
    'In Progress'
);
 "   DROP TYPE public.incident_status;
       public          postgres    false            _           1247    24991    service_status    TYPE     �   CREATE TYPE public.service_status AS ENUM (
    'Operational',
    'Degraded Performance',
    'Partial Outage',
    'Major Outage'
);
 !   DROP TYPE public.service_status;
       public          postgres    false            �            1259    25094    incident_service_links    TABLE     y   CREATE TABLE public.incident_service_links (
    id integer NOT NULL,
    incident_id integer,
    service_id integer
);
 *   DROP TABLE public.incident_service_links;
       public         heap    postgres    false            �            1259    25093    incident_service_links_id_seq    SEQUENCE     �   CREATE SEQUENCE public.incident_service_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.incident_service_links_id_seq;
       public          postgres    false    218            �           0    0    incident_service_links_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.incident_service_links_id_seq OWNED BY public.incident_service_links.id;
          public          postgres    false    217            �            1259    25289    incident_updates    TABLE     �   CREATE TABLE public.incident_updates (
    id integer NOT NULL,
    incident_id integer,
    message text,
    status public.incident_status NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 $   DROP TABLE public.incident_updates;
       public         heap    postgres    false    866            �            1259    25288    incident_updates_id_seq    SEQUENCE     �   CREATE SEQUENCE public.incident_updates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.incident_updates_id_seq;
       public          postgres    false    233            �           0    0    incident_updates_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.incident_updates_id_seq OWNED BY public.incident_updates.id;
          public          postgres    false    232            �            1259    25238 	   incidents    TABLE     �  CREATE TABLE public.incidents (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    organization_id integer,
    status public.incident_status DEFAULT 'Open'::public.incident_status,
    is_scheduled_maintenance boolean DEFAULT false,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    created_by_user_id character varying(50)
);
    DROP TABLE public.incidents;
       public         heap    postgres    false    866    866            �            1259    25237    incidents_id_seq    SEQUENCE     �   CREATE SEQUENCE public.incidents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.incidents_id_seq;
       public          postgres    false    229            �           0    0    incidents_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.incidents_id_seq OWNED BY public.incidents.id;
          public          postgres    false    228            �            1259    25341    notifications    TABLE       CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id character varying(50) NOT NULL,
    message character varying NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    service_name character varying(100) NOT NULL
);
 !   DROP TABLE public.notifications;
       public         heap    postgres    false            �            1259    25340    notifications_id_seq    SEQUENCE     �   CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.notifications_id_seq;
       public          postgres    false    237            �           0    0    notifications_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;
          public          postgres    false    236            �            1259    25019    organizations    TABLE     �   CREATE TABLE public.organizations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 !   DROP TABLE public.organizations;
       public         heap    postgres    false            �            1259    25018    organizations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.organizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.organizations_id_seq;
       public          postgres    false    216            �           0    0    organizations_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;
          public          postgres    false    215            �            1259    24985    persons    TABLE     �   CREATE TABLE public.persons (
    personid integer,
    lastname character varying(255),
    firstname character varying(255),
    address character varying(255),
    city character varying(255)
);
    DROP TABLE public.persons;
       public         heap    postgres    false            �            1259    25131    public_status_pages    TABLE     �   CREATE TABLE public.public_status_pages (
    id integer NOT NULL,
    organization_id integer,
    custom_domain character varying(255),
    is_enabled boolean DEFAULT true
);
 '   DROP TABLE public.public_status_pages;
       public         heap    postgres    false            �            1259    25130    public_status_pages_id_seq    SEQUENCE     �   CREATE SEQUENCE public.public_status_pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.public_status_pages_id_seq;
       public          postgres    false    220            �           0    0    public_status_pages_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.public_status_pages_id_seq OWNED BY public.public_status_pages.id;
          public          postgres    false    219            �            1259    25254    services    TABLE     �   CREATE TABLE public.services (
    id integer NOT NULL,
    team_id integer,
    name character varying(100) NOT NULL,
    description text,
    current_status public.service_status DEFAULT 'Operational'::public.service_status
);
    DROP TABLE public.services;
       public         heap    postgres    false    863    863            �            1259    25253    services_id_seq    SEQUENCE     �   CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.services_id_seq;
       public          postgres    false    231            �           0    0    services_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;
          public          postgres    false    230            �            1259    25304    subscriptions    TABLE     �   CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    user_id character varying(50) NOT NULL,
    service_id integer NOT NULL
);
 !   DROP TABLE public.subscriptions;
       public         heap    postgres    false            �            1259    25303    subscriptions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.subscriptions_id_seq;
       public          postgres    false    235            �           0    0    subscriptions_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;
          public          postgres    false    234            �            1259    25178    team_memberships    TABLE     �   CREATE TABLE public.team_memberships (
    id integer NOT NULL,
    team_id integer,
    user_id character varying(50),
    role character varying(50) DEFAULT 'member'::character varying,
    membership_status boolean DEFAULT false
);
 $   DROP TABLE public.team_memberships;
       public         heap    postgres    false            �            1259    25177    team_memberships_id_seq    SEQUENCE     �   CREATE SEQUENCE public.team_memberships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.team_memberships_id_seq;
       public          postgres    false    225            �           0    0    team_memberships_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.team_memberships_id_seq OWNED BY public.team_memberships.id;
          public          postgres    false    224            �            1259    25166    teams    TABLE     ~   CREATE TABLE public.teams (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    organization_id integer
);
    DROP TABLE public.teams;
       public         heap    postgres    false            �            1259    25165    teams_id_seq    SEQUENCE     �   CREATE SEQUENCE public.teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.teams_id_seq;
       public          postgres    false    223            �           0    0    teams_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;
          public          postgres    false    222            �            1259    25196    user_organizations    TABLE     �   CREATE TABLE public.user_organizations (
    id integer NOT NULL,
    user_id character varying(50),
    organization_id integer,
    role character varying(50) DEFAULT 'member'::character varying
);
 &   DROP TABLE public.user_organizations;
       public         heap    postgres    false            �            1259    25195    user_organizations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_organizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.user_organizations_id_seq;
       public          postgres    false    227            �           0    0    user_organizations_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.user_organizations_id_seq OWNED BY public.user_organizations.id;
          public          postgres    false    226            �            1259    25154    users    TABLE     }  CREATE TABLE public.users (
    id character varying(50) NOT NULL,
    firstname character varying(100) NOT NULL,
    lastname character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    role character varying(50) DEFAULT 'member'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    organization_id integer
);
    DROP TABLE public.users;
       public         heap    postgres    false            �           2604    25097    incident_service_links id    DEFAULT     �   ALTER TABLE ONLY public.incident_service_links ALTER COLUMN id SET DEFAULT nextval('public.incident_service_links_id_seq'::regclass);
 H   ALTER TABLE public.incident_service_links ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217    218            �           2604    25292    incident_updates id    DEFAULT     z   ALTER TABLE ONLY public.incident_updates ALTER COLUMN id SET DEFAULT nextval('public.incident_updates_id_seq'::regclass);
 B   ALTER TABLE public.incident_updates ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    233    233            �           2604    25241    incidents id    DEFAULT     l   ALTER TABLE ONLY public.incidents ALTER COLUMN id SET DEFAULT nextval('public.incidents_id_seq'::regclass);
 ;   ALTER TABLE public.incidents ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    229    229            �           2604    25344    notifications id    DEFAULT     t   ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);
 ?   ALTER TABLE public.notifications ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    237    237            �           2604    25022    organizations id    DEFAULT     t   ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);
 ?   ALTER TABLE public.organizations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    216    216            �           2604    25134    public_status_pages id    DEFAULT     �   ALTER TABLE ONLY public.public_status_pages ALTER COLUMN id SET DEFAULT nextval('public.public_status_pages_id_seq'::regclass);
 E   ALTER TABLE public.public_status_pages ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    220    220            �           2604    25257    services id    DEFAULT     j   ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);
 :   ALTER TABLE public.services ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    231    230    231            �           2604    25307    subscriptions id    DEFAULT     t   ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);
 ?   ALTER TABLE public.subscriptions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    235    234    235            �           2604    25181    team_memberships id    DEFAULT     z   ALTER TABLE ONLY public.team_memberships ALTER COLUMN id SET DEFAULT nextval('public.team_memberships_id_seq'::regclass);
 B   ALTER TABLE public.team_memberships ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    224    225            �           2604    25236    teams id    DEFAULT     d   ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);
 7   ALTER TABLE public.teams ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    223    223            �           2604    25199    user_organizations id    DEFAULT     ~   ALTER TABLE ONLY public.user_organizations ALTER COLUMN id SET DEFAULT nextval('public.user_organizations_id_seq'::regclass);
 D   ALTER TABLE public.user_organizations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227            w          0    25094    incident_service_links 
   TABLE DATA           M   COPY public.incident_service_links (id, incident_id, service_id) FROM stdin;
    public          postgres    false    218   y       �          0    25289    incident_updates 
   TABLE DATA           Y   COPY public.incident_updates (id, incident_id, message, status, "timestamp") FROM stdin;
    public          postgres    false    233   �       �          0    25238 	   incidents 
   TABLE DATA           �   COPY public.incidents (id, title, description, organization_id, status, is_scheduled_maintenance, start_time, end_time, created_by_user_id) FROM stdin;
    public          postgres    false    229   r�       �          0    25341    notifications 
   TABLE DATA           X   COPY public.notifications (id, user_id, message, "timestamp", service_name) FROM stdin;
    public          postgres    false    237   1�       u          0    25019    organizations 
   TABLE DATA           =   COPY public.organizations (id, name, created_at) FROM stdin;
    public          postgres    false    216   �       s          0    24985    persons 
   TABLE DATA           O   COPY public.persons (personid, lastname, firstname, address, city) FROM stdin;
    public          postgres    false    214   B�       y          0    25131    public_status_pages 
   TABLE DATA           ]   COPY public.public_status_pages (id, organization_id, custom_domain, is_enabled) FROM stdin;
    public          postgres    false    220   _�       �          0    25254    services 
   TABLE DATA           R   COPY public.services (id, team_id, name, description, current_status) FROM stdin;
    public          postgres    false    231   ��       �          0    25304    subscriptions 
   TABLE DATA           @   COPY public.subscriptions (id, user_id, service_id) FROM stdin;
    public          postgres    false    235   T�       ~          0    25178    team_memberships 
   TABLE DATA           Y   COPY public.team_memberships (id, team_id, user_id, role, membership_status) FROM stdin;
    public          postgres    false    225   ��       |          0    25166    teams 
   TABLE DATA           :   COPY public.teams (id, name, organization_id) FROM stdin;
    public          postgres    false    223   M�       �          0    25196    user_organizations 
   TABLE DATA           P   COPY public.user_organizations (id, user_id, organization_id, role) FROM stdin;
    public          postgres    false    227   ��       z          0    25154    users 
   TABLE DATA           b   COPY public.users (id, firstname, lastname, email, role, created_at, organization_id) FROM stdin;
    public          postgres    false    221   ��       �           0    0    incident_service_links_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.incident_service_links_id_seq', 34, true);
          public          postgres    false    217            �           0    0    incident_updates_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.incident_updates_id_seq', 22, true);
          public          postgres    false    232            �           0    0    incidents_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.incidents_id_seq', 36, true);
          public          postgres    false    228            �           0    0    notifications_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.notifications_id_seq', 2, true);
          public          postgres    false    236            �           0    0    organizations_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.organizations_id_seq', 16, true);
          public          postgres    false    215            �           0    0    public_status_pages_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.public_status_pages_id_seq', 1, true);
          public          postgres    false    219            �           0    0    services_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.services_id_seq', 8, true);
          public          postgres    false    230            �           0    0    subscriptions_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.subscriptions_id_seq', 21, true);
          public          postgres    false    234            �           0    0    team_memberships_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.team_memberships_id_seq', 12, true);
          public          postgres    false    224            �           0    0    teams_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.teams_id_seq', 15, true);
          public          postgres    false    222            �           0    0    user_organizations_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.user_organizations_id_seq', 1, false);
          public          postgres    false    226            �           2606    25099 2   incident_service_links incident_service_links_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.incident_service_links
    ADD CONSTRAINT incident_service_links_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.incident_service_links DROP CONSTRAINT incident_service_links_pkey;
       public            postgres    false    218            �           2606    25297 &   incident_updates incident_updates_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.incident_updates
    ADD CONSTRAINT incident_updates_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.incident_updates DROP CONSTRAINT incident_updates_pkey;
       public            postgres    false    233            �           2606    25247    incidents incidents_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.incidents DROP CONSTRAINT incidents_pkey;
       public            postgres    false    229            �           2606    25349     notifications notifications_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.notifications DROP CONSTRAINT notifications_pkey;
       public            postgres    false    237            �           2606    25025     organizations organizations_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.organizations DROP CONSTRAINT organizations_pkey;
       public            postgres    false    216            �           2606    25137 ,   public_status_pages public_status_pages_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.public_status_pages
    ADD CONSTRAINT public_status_pages_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.public_status_pages DROP CONSTRAINT public_status_pages_pkey;
       public            postgres    false    220            �           2606    25262    services services_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.services DROP CONSTRAINT services_pkey;
       public            postgres    false    231            �           2606    25309     subscriptions subscriptions_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_pkey;
       public            postgres    false    235            �           2606    25184 &   team_memberships team_memberships_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.team_memberships DROP CONSTRAINT team_memberships_pkey;
       public            postgres    false    225            �           2606    25171    teams teams_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.teams DROP CONSTRAINT teams_pkey;
       public            postgres    false    223            �           2606    25202 *   user_organizations user_organizations_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.user_organizations
    ADD CONSTRAINT user_organizations_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.user_organizations DROP CONSTRAINT user_organizations_pkey;
       public            postgres    false    227            �           2606    25204 A   user_organizations user_organizations_user_id_organization_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.user_organizations
    ADD CONSTRAINT user_organizations_user_id_organization_id_key UNIQUE (user_id, organization_id);
 k   ALTER TABLE ONLY public.user_organizations DROP CONSTRAINT user_organizations_user_id_organization_id_key;
       public            postgres    false    227    227            �           2606    25162    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            postgres    false    221            �           2606    25160    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    221            �           2606    25215    users fk_users_organization    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_organization FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE SET NULL;
 E   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_users_organization;
       public          postgres    false    3261    216    221            �           2606    25298 2   incident_updates incident_updates_incident_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.incident_updates
    ADD CONSTRAINT incident_updates_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.incident_updates DROP CONSTRAINT incident_updates_incident_id_fkey;
       public          postgres    false    3279    229    233            �           2606    25248 (   incidents incidents_organization_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.incidents DROP CONSTRAINT incidents_organization_id_fkey;
       public          postgres    false    229    216    3261            �           2606    25350 (   notifications notifications_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.notifications DROP CONSTRAINT notifications_user_id_fkey;
       public          postgres    false    221    3269    237            �           2606    25138 <   public_status_pages public_status_pages_organization_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.public_status_pages
    ADD CONSTRAINT public_status_pages_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
 f   ALTER TABLE ONLY public.public_status_pages DROP CONSTRAINT public_status_pages_organization_id_fkey;
       public          postgres    false    3261    216    220            �           2606    25263    services services_team_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.services DROP CONSTRAINT services_team_id_fkey;
       public          postgres    false    223    3271    231            �           2606    25315 +   subscriptions subscriptions_service_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_service_id_fkey;
       public          postgres    false    235    3281    231            �           2606    25310 (   subscriptions subscriptions_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_user_id_fkey;
       public          postgres    false    221    3269    235            �           2606    25185 .   team_memberships team_memberships_team_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.team_memberships DROP CONSTRAINT team_memberships_team_id_fkey;
       public          postgres    false    3271    225    223            �           2606    25190 .   team_memberships team_memberships_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.team_memberships DROP CONSTRAINT team_memberships_user_id_fkey;
       public          postgres    false    225    221    3269            �           2606    25172     teams teams_organization_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);
 J   ALTER TABLE ONLY public.teams DROP CONSTRAINT teams_organization_id_fkey;
       public          postgres    false    216    223    3261            �           2606    25210 :   user_organizations user_organizations_organization_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_organizations
    ADD CONSTRAINT user_organizations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;
 d   ALTER TABLE ONLY public.user_organizations DROP CONSTRAINT user_organizations_organization_id_fkey;
       public          postgres    false    3261    227    216            �           2606    25205 2   user_organizations user_organizations_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_organizations
    ADD CONSTRAINT user_organizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.user_organizations DROP CONSTRAINT user_organizations_user_id_fkey;
       public          postgres    false    221    227    3269            w   f   x���1B�3e�^{{I�uN�I��`��� �^�������߅�� 	��@�a�Uj/P{�6��@o7��'���l\^]û��$�����?A      �   s  x�}�=n1�k�s�)� U��i��`c���A�n X��G�=>�A����_���>�ڏ�"ۘ&�tk�,(���>�����ؾ�_����R��S��R$�'|���1�@a���79N�����������:����/���99Z�3�e���zy����+-�s� ��V�K�5� ���<4�R�8@���d�4�S&2����J�{#��� }�U��$����m�S��FV��o*4��F�b�\9�%f:Y[������Ieش����)?¼��)e$@�ܨ�Ty�ᷱ�r,�9���D��`�.��a6���k9�_��3n��zb��."�a1EZ)3�Bi��t�����E��5D�9��      �   �  x���oo�0�_��_��m�$��jZ�nUWM}Qi���0%��3M��R���,K���|�BHLK�m����#�ڼ��^���w������~���y���m�߯��mL����v�)b�?�^�)��h|�"¢���Pz�������
4�&�\��(_-yh�E� �<�[���i��Zqd8�
�&���2�\!�`̏���ͱ#}�D� �(��sɥI�5���Ǔ�a��zRu���<��PÀm�����F=c��������^sq���S�m�C�BiҴ�DS-!D��+���ԟ��	$�%quZb7�w��ث~-�|	)D�J�hh���r�@�C*Q�~+�1!gE�b��!�Q8�b.] ��0;Ad!4Q�Zl���>N���4�ߝH�ip�"�^�k�f�_�� �/�      �   �   x�]�=�0 й=E/ )������%���)R���X��,��Է�9Ð�b7��Q�~_�H�eR��:F[툱�k�I┵�h�!��<�<���		�K�Qn���o~��$�_�1x��߈�2��+�����.���ɘd3�_P���T�ʦ��c�?��8�      u   P   x�3�IM�Pp�/*�4202�50�52R02�25�20�3��0���24�L,�H�D�1Q0��22�2��3�40�4����� ��      s      x������ � �      y   '   x�3�4�,.I,)-�+IM�H�/*�K���,����� � 	;      �   �   x�mNI� <�W��JI�6�JЋ'@X*D������`���L-HMr᚜�\���&�p�9�"�GJSL�$�Bb垼�pC�gb�z+�i�.�'��%1e��/:C�A1!��R�C.o���g�%�&t��l-Ou+u�k�d*b��
n�}m�L5����c�_�[�      �   �   x����
�@��u�02I;�(BA�H�(�^�Z;���q��?N�'���v�S�ܯu�������Z�����Դ�*�a��q�9�*���>�!!#AV��y	B%Rȫ�xes^!`�+(�^ 
§���I	�'���! A{����� ~�.�?      ~   @   x�3��,-N-�7�/�0���
4����+���4������M�MJ-�,�2�4$Au� ��      |   >   x�3�,//�4�2�̭T(IM�U��r-8�=CB<\<\}|@
L9�32KR9͸b���� �v�      �      x������ � �      z     x�}��n�@���)|��˲{��S�_-�ژ4kE��
��O_-66Mګ����r�܇�V����z�$�I�.�b����u��b�pu����y3_׻U���|ߦ�i�$�ۄ��jT�+M."j��RnG���;M�Ӡ�G���<�}p#}���f5�����K�t�7��(U(�-m&�͛��QE�c��+]�����b׃  ׅ��A&�.uF�\�P)P�[����2�M��ms:ѯâ���僿�� U\(�LGp����i�'~��     