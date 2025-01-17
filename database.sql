-- ------------------------------------------
-- Friendica 2019.09-dev (Dalmatian Bellflower)
-- DB_UPDATE_VERSION 1319
-- ------------------------------------------


--
-- TABLE 2fa_recovery_codes
--
CREATE TABLE IF NOT EXISTS `2fa_recovery_codes` (
	`uid` mediumint unsigned NOT NULL COMMENT 'User ID',
	`code` varchar(50) NOT NULL COMMENT 'Recovery code string',
	`generated` datetime NOT NULL COMMENT 'Datetime the code was generated',
	`used` datetime COMMENT 'Datetime the code was used',
	 PRIMARY KEY(`uid`,`code`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Two-factor authentication recovery codes';

--
-- TABLE addon
--
CREATE TABLE IF NOT EXISTS `addon` (
	`id` int unsigned NOT NULL auto_increment COMMENT '',
	`name` varchar(50) NOT NULL DEFAULT '' COMMENT 'addon base (file)name',
	`version` varchar(50) NOT NULL DEFAULT '' COMMENT 'currently unused',
	`installed` boolean NOT NULL DEFAULT '0' COMMENT 'currently always 1',
	`hidden` boolean NOT NULL DEFAULT '0' COMMENT 'currently unused',
	`timestamp` int unsigned NOT NULL DEFAULT 0 COMMENT 'file timestamp to check for reloads',
	`plugin_admin` boolean NOT NULL DEFAULT '0' COMMENT '1 = has admin config, 0 = has no admin config',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `name` (`name`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='registered addons';

--
-- TABLE apcontact
--
CREATE TABLE IF NOT EXISTS `apcontact` (
	`url` varbinary(255) NOT NULL COMMENT 'URL of the contact',
	`uuid` varchar(255) COMMENT '',
	`type` varchar(20) NOT NULL COMMENT '',
	`following` varchar(255) COMMENT '',
	`followers` varchar(255) COMMENT '',
	`inbox` varchar(255) NOT NULL COMMENT '',
	`outbox` varchar(255) COMMENT '',
	`sharedinbox` varchar(255) COMMENT '',
	`manually-approve` boolean COMMENT '',
	`nick` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`name` varchar(255) COMMENT '',
	`about` text COMMENT '',
	`photo` varchar(255) COMMENT '',
	`addr` varchar(255) COMMENT '',
	`alias` varchar(255) COMMENT '',
	`pubkey` text COMMENT '',
	`baseurl` varchar(255) COMMENT 'baseurl of the ap contact',
	`generator` varchar(255) COMMENT 'Name of the contact\'s system',
	`updated` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	 PRIMARY KEY(`url`),
	 INDEX `addr` (`addr`(32)),
	 INDEX `alias` (`alias`(190)),
	 INDEX `url` (`followers`(190))
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='ActivityPub compatible contacts - used in the ActivityPub implementation';

--
-- TABLE attach
--
CREATE TABLE IF NOT EXISTS `attach` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'generated index',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Owner User id',
	`hash` varchar(64) NOT NULL DEFAULT '' COMMENT 'hash',
	`filename` varchar(255) NOT NULL DEFAULT '' COMMENT 'filename of original',
	`filetype` varchar(64) NOT NULL DEFAULT '' COMMENT 'mimetype',
	`filesize` int unsigned NOT NULL DEFAULT 0 COMMENT 'size in bytes',
	`data` longblob NOT NULL COMMENT 'file data',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'creation time',
	`edited` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'last edit time',
	`allow_cid` mediumtext COMMENT 'Access Control - list of allowed contact.id \'<19><78>',
	`allow_gid` mediumtext COMMENT 'Access Control - list of allowed groups',
	`deny_cid` mediumtext COMMENT 'Access Control - list of denied contact.id',
	`deny_gid` mediumtext COMMENT 'Access Control - list of denied groups',
	`backend-class` tinytext COMMENT 'Storage backend class',
	`backend-ref` text COMMENT 'Storage backend data reference',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='file attachments';

--
-- TABLE auth_codes
--
CREATE TABLE IF NOT EXISTS `auth_codes` (
	`id` varchar(40) NOT NULL COMMENT '',
	`client_id` varchar(20) NOT NULL DEFAULT '' COMMENT '',
	`redirect_uri` varchar(200) NOT NULL DEFAULT '' COMMENT '',
	`expires` int NOT NULL DEFAULT 0 COMMENT '',
	`scope` varchar(250) NOT NULL DEFAULT '' COMMENT '',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='OAuth usage';

--
-- TABLE cache
--
CREATE TABLE IF NOT EXISTS `cache` (
	`k` varbinary(255) NOT NULL COMMENT 'cache key',
	`v` mediumtext COMMENT 'cached serialized value',
	`expires` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'datetime of cache expiration',
	`updated` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'datetime of cache insertion',
	 PRIMARY KEY(`k`),
	 INDEX `k_expires` (`k`,`expires`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Stores temporary data';

--
-- TABLE challenge
--
CREATE TABLE IF NOT EXISTS `challenge` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`challenge` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`dfrn-id` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`expire` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`type` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`last_update` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='';

--
-- TABLE clients
--
CREATE TABLE IF NOT EXISTS `clients` (
	`client_id` varchar(20) NOT NULL COMMENT '',
	`pw` varchar(20) NOT NULL DEFAULT '' COMMENT '',
	`redirect_uri` varchar(200) NOT NULL DEFAULT '' COMMENT '',
	`name` text COMMENT '',
	`icon` text COMMENT '',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	 PRIMARY KEY(`client_id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='OAuth usage';

--
-- TABLE config
--
CREATE TABLE IF NOT EXISTS `config` (
	`id` int unsigned NOT NULL auto_increment COMMENT '',
	`cat` varbinary(50) NOT NULL DEFAULT '' COMMENT '',
	`k` varbinary(50) NOT NULL DEFAULT '' COMMENT '',
	`v` mediumtext COMMENT '',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `cat_k` (`cat`,`k`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='main configuration storage';

--
-- TABLE contact
--
CREATE TABLE IF NOT EXISTS `contact` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Owner User id',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`updated` datetime DEFAULT '0001-01-01 00:00:00' COMMENT 'Date of last contact update',
	`self` boolean NOT NULL DEFAULT '0' COMMENT '1 if the contact is the user him/her self',
	`remote_self` boolean NOT NULL DEFAULT '0' COMMENT '',
	`rel` tinyint unsigned NOT NULL DEFAULT 0 COMMENT 'The kind of the relation between the user and the contact',
	`duplex` boolean NOT NULL DEFAULT '0' COMMENT '',
	`network` char(4) NOT NULL DEFAULT '' COMMENT 'Network of the contact',
	`protocol` char(4) NOT NULL DEFAULT '' COMMENT 'Protocol of the contact',
	`name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name that this contact is known by',
	`nick` varchar(255) NOT NULL DEFAULT '' COMMENT 'Nick- and user name of the contact',
	`location` varchar(255) DEFAULT '' COMMENT '',
	`about` text COMMENT '',
	`keywords` text COMMENT 'public keywords (interests) of the contact',
	`gender` varchar(32) NOT NULL DEFAULT '' COMMENT '',
	`xmpp` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`attag` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`photo` varchar(255) DEFAULT '' COMMENT 'Link to the profile photo of the contact',
	`thumb` varchar(255) DEFAULT '' COMMENT 'Link to the profile photo (thumb size)',
	`micro` varchar(255) DEFAULT '' COMMENT 'Link to the profile photo (micro size)',
	`site-pubkey` text COMMENT '',
	`issued-id` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`dfrn-id` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`url` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`nurl` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`addr` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`alias` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`pubkey` text COMMENT 'RSA public key 4096 bit',
	`prvkey` text COMMENT 'RSA private key 4096 bit',
	`batch` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`request` varchar(255) COMMENT '',
	`notify` varchar(255) COMMENT '',
	`poll` varchar(255) COMMENT '',
	`confirm` varchar(255) COMMENT '',
	`poco` varchar(255) COMMENT '',
	`aes_allow` boolean NOT NULL DEFAULT '0' COMMENT '',
	`ret-aes` boolean NOT NULL DEFAULT '0' COMMENT '',
	`usehub` boolean NOT NULL DEFAULT '0' COMMENT '',
	`subhub` boolean NOT NULL DEFAULT '0' COMMENT '',
	`hub-verify` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`last-update` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Date of the last try to update the contact info',
	`success_update` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Date of the last successful contact update',
	`failure_update` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Date of the last failed update',
	`name-date` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`uri-date` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`avatar-date` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`term-date` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`last-item` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'date of the last post',
	`priority` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`blocked` boolean NOT NULL DEFAULT '1' COMMENT 'Node-wide block status',
	`block_reason` text COMMENT 'Node-wide block reason',
	`readonly` boolean NOT NULL DEFAULT '0' COMMENT 'posts of the contact are readonly',
	`writable` boolean NOT NULL DEFAULT '0' COMMENT '',
	`forum` boolean NOT NULL DEFAULT '0' COMMENT 'contact is a forum',
	`prv` boolean NOT NULL DEFAULT '0' COMMENT 'contact is a private group',
	`contact-type` tinyint NOT NULL DEFAULT 0 COMMENT '',
	`hidden` boolean NOT NULL DEFAULT '0' COMMENT '',
	`archive` boolean NOT NULL DEFAULT '0' COMMENT '',
	`pending` boolean NOT NULL DEFAULT '1' COMMENT '',
	`deleted` boolean NOT NULL DEFAULT '0' COMMENT 'Contact has been deleted',
	`rating` tinyint NOT NULL DEFAULT 0 COMMENT '',
	`unsearchable` boolean NOT NULL DEFAULT '0' COMMENT 'Contact prefers to not be searchable',
	`sensitive` boolean NOT NULL DEFAULT '0' COMMENT 'Contact posts sensitive content',
	`baseurl` varchar(255) DEFAULT '' COMMENT 'baseurl of the contact',
	`reason` text COMMENT '',
	`closeness` tinyint unsigned NOT NULL DEFAULT 99 COMMENT '',
	`info` mediumtext COMMENT '',
	`profile-id` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`bdyear` varchar(4) NOT NULL DEFAULT '' COMMENT '',
	`bd` date NOT NULL DEFAULT '0001-01-01' COMMENT '',
	`notify_new_posts` boolean NOT NULL DEFAULT '0' COMMENT '',
	`fetch_further_information` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`ffi_keyword_blacklist` text COMMENT '',
	 PRIMARY KEY(`id`),
	 INDEX `uid_name` (`uid`,`name`(190)),
	 INDEX `self_uid` (`self`,`uid`),
	 INDEX `alias_uid` (`alias`(32),`uid`),
	 INDEX `pending_uid` (`pending`,`uid`),
	 INDEX `blocked_uid` (`blocked`,`uid`),
	 INDEX `uid_rel_network_poll` (`uid`,`rel`,`network`,`poll`(64),`archive`),
	 INDEX `uid_network_batch` (`uid`,`network`,`batch`(64)),
	 INDEX `addr_uid` (`addr`(32),`uid`),
	 INDEX `nurl_uid` (`nurl`(32),`uid`),
	 INDEX `nick_uid` (`nick`(32),`uid`),
	 INDEX `dfrn-id` (`dfrn-id`(64)),
	 INDEX `issued-id` (`issued-id`(64))
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='contact table';

--
-- TABLE conv
--
CREATE TABLE IF NOT EXISTS `conv` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`guid` varchar(255) NOT NULL DEFAULT '' COMMENT 'A unique identifier for this conversation',
	`recips` text COMMENT 'sender_handle;recipient_handle',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Owner User id',
	`creator` varchar(255) NOT NULL DEFAULT '' COMMENT 'handle of creator',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'creation timestamp',
	`updated` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'edited timestamp',
	`subject` text COMMENT 'subject of initial message',
	 PRIMARY KEY(`id`),
	 INDEX `uid` (`uid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='private messages';

--
-- TABLE conversation
--
CREATE TABLE IF NOT EXISTS `conversation` (
	`item-uri` varbinary(255) NOT NULL COMMENT 'Original URI of the item - unrelated to the table with the same name',
	`reply-to-uri` varbinary(255) NOT NULL DEFAULT '' COMMENT 'URI to which this item is a reply',
	`conversation-uri` varbinary(255) NOT NULL DEFAULT '' COMMENT 'GNU Social conversation URI',
	`conversation-href` varbinary(255) NOT NULL DEFAULT '' COMMENT 'GNU Social conversation link',
	`protocol` tinyint unsigned NOT NULL DEFAULT 255 COMMENT 'The protocol of the item',
	`source` mediumtext COMMENT 'Original source',
	`received` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Receiving date',
	 PRIMARY KEY(`item-uri`),
	 INDEX `conversation-uri` (`conversation-uri`),
	 INDEX `received` (`received`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Raw data and structure information for messages';

--
-- TABLE diaspora-interaction
--
CREATE TABLE IF NOT EXISTS `diaspora-interaction` (
	`uri-id` int unsigned NOT NULL COMMENT 'Id of the item-uri table entry that contains the item uri',
	`interaction` mediumtext COMMENT 'The Diaspora interaction',
	 PRIMARY KEY(`uri-id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Signed Diaspora Interaction';

--
-- TABLE event
--
CREATE TABLE IF NOT EXISTS `event` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`guid` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Owner User id',
	`cid` int unsigned NOT NULL DEFAULT 0 COMMENT 'contact_id (ID of the contact in contact table)',
	`uri` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'creation time',
	`edited` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'last edit time',
	`start` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'event start time',
	`finish` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'event end time',
	`summary` text COMMENT 'short description or title of the event',
	`desc` text COMMENT 'event description',
	`location` text COMMENT 'event location',
	`type` varchar(20) NOT NULL DEFAULT '' COMMENT 'event or birthday',
	`nofinish` boolean NOT NULL DEFAULT '0' COMMENT 'if event does have no end this is 1',
	`adjust` boolean NOT NULL DEFAULT '1' COMMENT 'adjust to timezone of the recipient (0 or 1)',
	`ignore` boolean NOT NULL DEFAULT '0' COMMENT '0 or 1',
	`allow_cid` mediumtext COMMENT 'Access Control - list of allowed contact.id \'<19><78>\'',
	`allow_gid` mediumtext COMMENT 'Access Control - list of allowed groups',
	`deny_cid` mediumtext COMMENT 'Access Control - list of denied contact.id',
	`deny_gid` mediumtext COMMENT 'Access Control - list of denied groups',
	 PRIMARY KEY(`id`),
	 INDEX `uid_start` (`uid`,`start`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Events';

--
-- TABLE fcontact
--
CREATE TABLE IF NOT EXISTS `fcontact` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`guid` varchar(255) NOT NULL DEFAULT '' COMMENT 'unique id',
	`url` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`name` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`photo` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`request` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`nick` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`addr` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`batch` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`notify` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`poll` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`confirm` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`priority` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`network` char(4) NOT NULL DEFAULT '' COMMENT '',
	`alias` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`pubkey` text COMMENT '',
	`updated` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	 PRIMARY KEY(`id`),
	 INDEX `addr` (`addr`(32)),
	 UNIQUE INDEX `url` (`url`(190))
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Diaspora compatible contacts - used in the Diaspora implementation';

--
-- TABLE fsuggest
--
CREATE TABLE IF NOT EXISTS `fsuggest` (
	`id` int unsigned NOT NULL auto_increment COMMENT '',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`cid` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`name` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`url` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`request` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`photo` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`note` text COMMENT '',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='friend suggestion stuff';

--
-- TABLE gcign
--
CREATE TABLE IF NOT EXISTS `gcign` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Local User id',
	`gcid` int unsigned NOT NULL DEFAULT 0 COMMENT 'gcontact.id of ignored contact',
	 PRIMARY KEY(`id`),
	 INDEX `uid` (`uid`),
	 INDEX `gcid` (`gcid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='contacts ignored by friend suggestions';

--
-- TABLE gcontact
--
CREATE TABLE IF NOT EXISTS `gcontact` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name that this contact is known by',
	`nick` varchar(255) NOT NULL DEFAULT '' COMMENT 'Nick- and user name of the contact',
	`url` varchar(255) NOT NULL DEFAULT '' COMMENT 'Link to the contacts profile page',
	`nurl` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`photo` varchar(255) NOT NULL DEFAULT '' COMMENT 'Link to the profile photo',
	`connect` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`updated` datetime DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`last_contact` datetime DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`last_failure` datetime DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`archive_date` datetime DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`archived` boolean NOT NULL DEFAULT '0' COMMENT '',
	`location` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`about` text COMMENT '',
	`keywords` text COMMENT 'puplic keywords (interests)',
	`gender` varchar(32) NOT NULL DEFAULT '' COMMENT '',
	`birthday` varchar(32) NOT NULL DEFAULT '0001-01-01' COMMENT '',
	`community` boolean NOT NULL DEFAULT '0' COMMENT '1 if contact is forum account',
	`contact-type` tinyint NOT NULL DEFAULT -1 COMMENT '',
	`hide` boolean NOT NULL DEFAULT '0' COMMENT '1 = should be hidden from search',
	`nsfw` boolean NOT NULL DEFAULT '0' COMMENT '1 = contact posts nsfw content',
	`network` char(4) NOT NULL DEFAULT '' COMMENT 'social network protocol',
	`addr` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`notify` varchar(255) COMMENT '',
	`alias` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`generation` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`server_url` varchar(255) NOT NULL DEFAULT '' COMMENT 'baseurl of the contacts server',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `nurl` (`nurl`(190)),
	 INDEX `name` (`name`(64)),
	 INDEX `nick` (`nick`(32)),
	 INDEX `addr` (`addr`(64)),
	 INDEX `hide_network_updated` (`hide`,`network`,`updated`),
	 INDEX `updated` (`updated`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='global contacts';

--
-- TABLE glink
--
CREATE TABLE IF NOT EXISTS `glink` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`cid` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`gcid` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`zcid` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`updated` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `cid_uid_gcid_zcid` (`cid`,`uid`,`gcid`,`zcid`),
	 INDEX `gcid` (`gcid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='\'friends of friends\' linkages derived from poco';

--
-- TABLE group
--
CREATE TABLE IF NOT EXISTS `group` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Owner User id',
	`visible` boolean NOT NULL DEFAULT '0' COMMENT '1 indicates the member list is not private',
	`deleted` boolean NOT NULL DEFAULT '0' COMMENT '1 indicates the group has been deleted',
	`name` varchar(255) NOT NULL DEFAULT '' COMMENT 'human readable name of group',
	 PRIMARY KEY(`id`),
	 INDEX `uid` (`uid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='privacy groups, group info';

--
-- TABLE group_member
--
CREATE TABLE IF NOT EXISTS `group_member` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`gid` int unsigned NOT NULL DEFAULT 0 COMMENT 'groups.id of the associated group',
	`contact-id` int unsigned NOT NULL DEFAULT 0 COMMENT 'contact.id of the member assigned to the associated group',
	 PRIMARY KEY(`id`),
	 INDEX `contactid` (`contact-id`),
	 UNIQUE INDEX `gid_contactid` (`gid`,`contact-id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='privacy groups, member info';

--
-- TABLE gserver
--
CREATE TABLE IF NOT EXISTS `gserver` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`url` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`nurl` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`version` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`site_name` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`info` text COMMENT '',
	`register_policy` tinyint NOT NULL DEFAULT 0 COMMENT '',
	`registered-users` int unsigned NOT NULL DEFAULT 0 COMMENT 'Number of registered users',
	`poco` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`noscrape` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`network` char(4) NOT NULL DEFAULT '' COMMENT '',
	`platform` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`relay-subscribe` boolean NOT NULL DEFAULT '0' COMMENT 'Has the server subscribed to the relay system',
	`relay-scope` varchar(10) NOT NULL DEFAULT '' COMMENT 'The scope of messages that the server wants to get',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`last_poco_query` datetime DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`last_contact` datetime DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`last_failure` datetime DEFAULT '0001-01-01 00:00:00' COMMENT '',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `nurl` (`nurl`(190))
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Global servers';

--
-- TABLE gserver-tag
--
CREATE TABLE IF NOT EXISTS `gserver-tag` (
	`gserver-id` int unsigned NOT NULL DEFAULT 0 COMMENT 'The id of the gserver',
	`tag` varchar(100) NOT NULL DEFAULT '' COMMENT 'Tag that the server has subscribed',
	 PRIMARY KEY(`gserver-id`,`tag`),
	 INDEX `tag` (`tag`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Tags that the server has subscribed';

--
-- TABLE hook
--
CREATE TABLE IF NOT EXISTS `hook` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`hook` varbinary(100) NOT NULL DEFAULT '' COMMENT 'name of hook',
	`file` varbinary(200) NOT NULL DEFAULT '' COMMENT 'relative filename of hook handler',
	`function` varbinary(200) NOT NULL DEFAULT '' COMMENT 'function name of hook handler',
	`priority` smallint unsigned NOT NULL DEFAULT 0 COMMENT 'not yet implemented - can be used to sort conflicts in hook handling by calling handlers in priority order',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `hook_file_function` (`hook`,`file`,`function`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='addon hook registry';

--
-- TABLE inbox-status
--
CREATE TABLE IF NOT EXISTS `inbox-status` (
	`url` varbinary(255) NOT NULL COMMENT 'URL of the inbox',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Creation date of this entry',
	`success` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Date of the last successful delivery',
	`failure` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Date of the last failed delivery',
	`previous` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Previous delivery date',
	`archive` boolean NOT NULL DEFAULT '0' COMMENT 'Is the inbox archived?',
	`shared` boolean NOT NULL DEFAULT '0' COMMENT 'Is it a shared inbox?',
	 PRIMARY KEY(`url`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Status of ActivityPub inboxes';

--
-- TABLE intro
--
CREATE TABLE IF NOT EXISTS `intro` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`fid` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`contact-id` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`knowyou` boolean NOT NULL DEFAULT '0' COMMENT '',
	`duplex` boolean NOT NULL DEFAULT '0' COMMENT '',
	`note` text COMMENT '',
	`hash` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`datetime` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`blocked` boolean NOT NULL DEFAULT '1' COMMENT '',
	`ignore` boolean NOT NULL DEFAULT '0' COMMENT '',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='';

--
-- TABLE item
--
CREATE TABLE IF NOT EXISTS `item` (
	`id` int unsigned NOT NULL auto_increment,
	`guid` varchar(255) NOT NULL DEFAULT '' COMMENT 'A unique identifier for this item',
	`uri` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`uri-id` int unsigned COMMENT 'Id of the item-uri table entry that contains the item uri',
	`uri-hash` varchar(80) NOT NULL DEFAULT '' COMMENT 'RIPEMD-128 hash from uri',
	`parent` int unsigned NOT NULL DEFAULT 0 COMMENT 'item.id of the parent to this item if it is a reply of some form; otherwise this must be set to the id of this item',
	`parent-uri` varchar(255) NOT NULL DEFAULT '' COMMENT 'uri of the parent to this item',
	`parent-uri-id` int unsigned COMMENT 'Id of the item-uri table that contains the parent uri',
	`thr-parent` varchar(255) NOT NULL DEFAULT '' COMMENT 'If the parent of this item is not the top-level item in the conversation, the uri of the immediate parent; otherwise set to parent-uri',
	`thr-parent-id` int unsigned COMMENT 'Id of the item-uri table that contains the thread parent uri',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Creation timestamp.',
	`edited` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Date of last edit (default is created)',
	`commented` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Date of last comment/reply to this item',
	`received` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'datetime',
	`changed` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Date that something in the conversation changed, indicating clients should fetch the conversation again',
	`gravity` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`network` char(4) NOT NULL DEFAULT '' COMMENT 'Network from where the item comes from',
	`owner-id` int unsigned NOT NULL DEFAULT 0 COMMENT 'Link to the contact table with uid=0 of the owner of this item',
	`author-id` int unsigned NOT NULL DEFAULT 0 COMMENT 'Link to the contact table with uid=0 of the author of this item',
	`icid` int unsigned COMMENT 'Id of the item-content table entry that contains the whole item content',
	`iaid` int unsigned COMMENT 'Id of the item-activity table entry that contains the activity data',
	`extid` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`post-type` tinyint unsigned NOT NULL DEFAULT 0 COMMENT 'Post type (personal note, bookmark, ...)',
	`global` boolean NOT NULL DEFAULT '0' COMMENT '',
	`private` boolean NOT NULL DEFAULT '0' COMMENT 'distribution is restricted',
	`visible` boolean NOT NULL DEFAULT '0' COMMENT '',
	`moderated` boolean NOT NULL DEFAULT '0' COMMENT '',
	`deleted` boolean NOT NULL DEFAULT '0' COMMENT 'item has been deleted',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Owner id which owns this copy of the item',
	`contact-id` int unsigned NOT NULL DEFAULT 0 COMMENT 'contact.id',
	`wall` boolean NOT NULL DEFAULT '0' COMMENT 'This item was posted to the wall of uid',
	`origin` boolean NOT NULL DEFAULT '0' COMMENT 'item originated at this site',
	`pubmail` boolean NOT NULL DEFAULT '0' COMMENT '',
	`starred` boolean NOT NULL DEFAULT '0' COMMENT 'item has been favourited',
	`unseen` boolean NOT NULL DEFAULT '1' COMMENT 'item has not been seen',
	`mention` boolean NOT NULL DEFAULT '0' COMMENT 'The owner of this item was mentioned in it',
	`forum_mode` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`psid` int unsigned COMMENT 'ID of the permission set of this post',
	`resource-id` varchar(32) NOT NULL DEFAULT '' COMMENT 'Used to link other tables to items, it identifies the linked resource (e.g. photo) and if set must also set resource_type',
	`event-id` int unsigned NOT NULL DEFAULT 0 COMMENT 'Used to link to the event.id',
	`attach` mediumtext COMMENT 'JSON structure representing attachments to this item',
	`allow_cid` mediumtext COMMENT 'Deprecated',
	`allow_gid` mediumtext COMMENT 'Deprecated',
	`deny_cid` mediumtext COMMENT 'Deprecated',
	`deny_gid` mediumtext COMMENT 'Deprecated',
	`postopts` text COMMENT 'Deprecated',
	`inform` mediumtext COMMENT 'Deprecated',
	`type` varchar(20) COMMENT 'Deprecated',
	`bookmark` boolean COMMENT 'Deprecated',
	`file` mediumtext COMMENT 'Deprecated',
	`location` varchar(255) COMMENT 'Deprecated',
	`coord` varchar(255) COMMENT 'Deprecated',
	`tag` mediumtext COMMENT 'Deprecated',
	`plink` varchar(255) COMMENT 'Deprecated',
	`title` varchar(255) COMMENT 'Deprecated',
	`content-warning` varchar(255) COMMENT 'Deprecated',
	`body` mediumtext COMMENT 'Deprecated',
	`app` varchar(255) COMMENT 'Deprecated',
	`verb` varchar(100) COMMENT 'Deprecated',
	`object-type` varchar(100) COMMENT 'Deprecated',
	`object` text COMMENT 'Deprecated',
	`target-type` varchar(100) COMMENT 'Deprecated',
	`target` text COMMENT 'Deprecated',
	`author-name` varchar(255) COMMENT 'Deprecated',
	`author-link` varchar(255) COMMENT 'Deprecated',
	`author-avatar` varchar(255) COMMENT 'Deprecated',
	`owner-name` varchar(255) COMMENT 'Deprecated',
	`owner-link` varchar(255) COMMENT 'Deprecated',
	`owner-avatar` varchar(255) COMMENT 'Deprecated',
	`rendered-hash` varchar(32) COMMENT 'Deprecated',
	`rendered-html` mediumtext COMMENT 'Deprecated',
	 PRIMARY KEY(`id`),
	 INDEX `guid` (`guid`(191)),
	 INDEX `uri` (`uri`(191)),
	 INDEX `parent` (`parent`),
	 INDEX `parent-uri` (`parent-uri`(191)),
	 INDEX `extid` (`extid`(191)),
	 INDEX `uid_id` (`uid`,`id`),
	 INDEX `uid_contactid_id` (`uid`,`contact-id`,`id`),
	 INDEX `uid_received` (`uid`,`received`),
	 INDEX `uid_commented` (`uid`,`commented`),
	 INDEX `uid_unseen_contactid` (`uid`,`unseen`,`contact-id`),
	 INDEX `uid_network_received` (`uid`,`network`,`received`),
	 INDEX `uid_network_commented` (`uid`,`network`,`commented`),
	 INDEX `uid_thrparent` (`uid`,`thr-parent`(190)),
	 INDEX `uid_parenturi` (`uid`,`parent-uri`(190)),
	 INDEX `uid_contactid_received` (`uid`,`contact-id`,`received`),
	 INDEX `authorid_received` (`author-id`,`received`),
	 INDEX `ownerid` (`owner-id`),
	 INDEX `contact-id` (`contact-id`),
	 INDEX `uid_uri` (`uid`,`uri`(190)),
	 INDEX `resource-id` (`resource-id`),
	 INDEX `deleted_changed` (`deleted`,`changed`),
	 INDEX `uid_wall_changed` (`uid`,`wall`,`changed`),
	 INDEX `uid_eventid` (`uid`,`event-id`),
	 INDEX `icid` (`icid`),
	 INDEX `iaid` (`iaid`),
	 INDEX `psid_wall` (`psid`,`wall`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Structure for all posts';

--
-- TABLE item-activity
--
CREATE TABLE IF NOT EXISTS `item-activity` (
	`id` int unsigned NOT NULL auto_increment,
	`uri` varchar(255) COMMENT '',
	`uri-id` int unsigned COMMENT 'Id of the item-uri table entry that contains the item uri',
	`uri-hash` varchar(80) NOT NULL DEFAULT '' COMMENT 'RIPEMD-128 hash from uri',
	`activity` smallint unsigned NOT NULL DEFAULT 0 COMMENT '',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `uri-hash` (`uri-hash`),
	 INDEX `uri` (`uri`(191)),
	 INDEX `uri-id` (`uri-id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Activities for items';

--
-- TABLE item-content
--
CREATE TABLE IF NOT EXISTS `item-content` (
	`id` int unsigned NOT NULL auto_increment,
	`uri` varchar(255) COMMENT '',
	`uri-id` int unsigned COMMENT 'Id of the item-uri table entry that contains the item uri',
	`uri-plink-hash` varchar(80) NOT NULL DEFAULT '' COMMENT 'RIPEMD-128 hash from uri',
	`title` varchar(255) NOT NULL DEFAULT '' COMMENT 'item title',
	`content-warning` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`body` mediumtext COMMENT 'item body content',
	`location` varchar(255) NOT NULL DEFAULT '' COMMENT 'text location where this item originated',
	`coord` varchar(255) NOT NULL DEFAULT '' COMMENT 'longitude/latitude pair representing location where this item originated',
	`language` text COMMENT 'Language information about this post',
	`app` varchar(255) NOT NULL DEFAULT '' COMMENT 'application which generated this item',
	`rendered-hash` varchar(32) NOT NULL DEFAULT '' COMMENT '',
	`rendered-html` mediumtext COMMENT 'item.body converted to html',
	`object-type` varchar(100) NOT NULL DEFAULT '' COMMENT 'ActivityStreams object type',
	`object` text COMMENT 'JSON encoded object structure unless it is an implied object (normal post)',
	`target-type` varchar(100) NOT NULL DEFAULT '' COMMENT 'ActivityStreams target type if applicable (URI)',
	`target` text COMMENT 'JSON encoded target structure if used',
	`plink` varchar(255) NOT NULL DEFAULT '' COMMENT 'permalink or URL to a displayable copy of the message at its source',
	`verb` varchar(100) NOT NULL DEFAULT '' COMMENT 'ActivityStreams verb',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `uri-plink-hash` (`uri-plink-hash`),
	 INDEX `uri` (`uri`(191)),
	 INDEX `plink` (`plink`(191)),
	 INDEX `uri-id` (`uri-id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Content for all posts';

--
-- TABLE item-delivery-data
--
CREATE TABLE IF NOT EXISTS `item-delivery-data` (
	`iid` int unsigned NOT NULL COMMENT 'Item id',
	`postopts` text COMMENT 'External post connectors add their network name to this comma-separated string to identify that they should be delivered to these networks during delivery',
	`inform` mediumtext COMMENT 'Additional receivers of the linked item',
	`queue_count` mediumint NOT NULL DEFAULT 0 COMMENT 'Initial number of delivery recipients, used as item.delivery_queue_count',
	`queue_done` mediumint NOT NULL DEFAULT 0 COMMENT 'Number of successful deliveries, used as item.delivery_queue_done',
	`activitypub` mediumint NOT NULL DEFAULT 0 COMMENT 'Number of successful deliveries via ActivityPub',
	`dfrn` mediumint NOT NULL DEFAULT 0 COMMENT 'Number of successful deliveries via DFRN',
	`legacy_dfrn` mediumint NOT NULL DEFAULT 0 COMMENT 'Number of successful deliveries via legacy DFRN',
	`diaspora` mediumint NOT NULL DEFAULT 0 COMMENT 'Number of successful deliveries via Diaspora',
	`ostatus` mediumint NOT NULL DEFAULT 0 COMMENT 'Number of successful deliveries via OStatus',
	 PRIMARY KEY(`iid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Delivery data for items';

--
-- TABLE item-uri
--
CREATE TABLE IF NOT EXISTS `item-uri` (
	`id` int unsigned NOT NULL auto_increment,
	`uri` varbinary(255) NOT NULL COMMENT 'URI of an item',
	`guid` varbinary(255) COMMENT 'A unique identifier for an item',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `uri` (`uri`),
	 INDEX `guid` (`guid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='URI and GUID for items';

--
-- TABLE locks
--
CREATE TABLE IF NOT EXISTS `locks` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`name` varchar(128) NOT NULL DEFAULT '' COMMENT '',
	`locked` boolean NOT NULL DEFAULT '0' COMMENT '',
	`pid` int unsigned NOT NULL DEFAULT 0 COMMENT 'Process ID',
	`expires` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'datetime of cache expiration',
	 PRIMARY KEY(`id`),
	 INDEX `name_expires` (`name`,`expires`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='';

--
-- TABLE mail
--
CREATE TABLE IF NOT EXISTS `mail` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Owner User id',
	`guid` varchar(255) NOT NULL DEFAULT '' COMMENT 'A unique identifier for this private message',
	`from-name` varchar(255) NOT NULL DEFAULT '' COMMENT 'name of the sender',
	`from-photo` varchar(255) NOT NULL DEFAULT '' COMMENT 'contact photo link of the sender',
	`from-url` varchar(255) NOT NULL DEFAULT '' COMMENT 'profile linke of the sender',
	`contact-id` varchar(255) NOT NULL DEFAULT '' COMMENT 'contact.id',
	`convid` int unsigned NOT NULL DEFAULT 0 COMMENT 'conv.id',
	`title` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`body` mediumtext COMMENT '',
	`seen` boolean NOT NULL DEFAULT '0' COMMENT 'if message visited it is 1',
	`reply` boolean NOT NULL DEFAULT '0' COMMENT '',
	`replied` boolean NOT NULL DEFAULT '0' COMMENT '',
	`unknown` boolean NOT NULL DEFAULT '0' COMMENT 'if sender not in the contact table this is 1',
	`uri` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`parent-uri` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'creation time of the private message',
	 PRIMARY KEY(`id`),
	 INDEX `uid_seen` (`uid`,`seen`),
	 INDEX `convid` (`convid`),
	 INDEX `uri` (`uri`(64)),
	 INDEX `parent-uri` (`parent-uri`(64)),
	 INDEX `contactid` (`contact-id`(32))
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='private messages';

--
-- TABLE mailacct
--
CREATE TABLE IF NOT EXISTS `mailacct` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`server` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`port` smallint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`ssltype` varchar(16) NOT NULL DEFAULT '' COMMENT '',
	`mailbox` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`user` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`pass` text COMMENT '',
	`reply_to` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`action` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`movetofolder` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`pubmail` boolean NOT NULL DEFAULT '0' COMMENT '',
	`last_check` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Mail account data for fetching mails';

--
-- TABLE manage
--
CREATE TABLE IF NOT EXISTS `manage` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`mid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `uid_mid` (`uid`,`mid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='table of accounts that can manage each other';

--
-- TABLE notify
--
CREATE TABLE IF NOT EXISTS `notify` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`hash` varchar(64) NOT NULL DEFAULT '' COMMENT '',
	`type` smallint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`name` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`url` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`photo` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`date` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`msg` mediumtext COMMENT '',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Owner User id',
	`link` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`iid` int unsigned NOT NULL DEFAULT 0 COMMENT 'item.id',
	`parent` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`seen` boolean NOT NULL DEFAULT '0' COMMENT '',
	`verb` varchar(100) NOT NULL DEFAULT '' COMMENT '',
	`otype` varchar(10) NOT NULL DEFAULT '' COMMENT '',
	`name_cache` tinytext COMMENT 'Cached bbcode parsing of name',
	`msg_cache` mediumtext COMMENT 'Cached bbcode parsing of msg',
	 PRIMARY KEY(`id`),
	 INDEX `hash_uid` (`hash`,`uid`),
	 INDEX `seen_uid_date` (`seen`,`uid`,`date`),
	 INDEX `uid_date` (`uid`,`date`),
	 INDEX `uid_type_link` (`uid`,`type`,`link`(190))
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='notifications';

--
-- TABLE notify-threads
--
CREATE TABLE IF NOT EXISTS `notify-threads` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`notify-id` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`master-parent-item` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`parent-item` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`receiver-uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='';

--
-- TABLE oembed
--
CREATE TABLE IF NOT EXISTS `oembed` (
	`url` varbinary(255) NOT NULL COMMENT 'page url',
	`maxwidth` mediumint unsigned NOT NULL COMMENT 'Maximum width passed to Oembed',
	`content` mediumtext COMMENT 'OEmbed data of the page',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'datetime of creation',
	 PRIMARY KEY(`url`,`maxwidth`),
	 INDEX `created` (`created`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='cache for OEmbed queries';

--
-- TABLE openwebauth-token
--
CREATE TABLE IF NOT EXISTS `openwebauth-token` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`type` varchar(32) NOT NULL DEFAULT '' COMMENT 'Verify type',
	`token` varchar(255) NOT NULL DEFAULT '' COMMENT 'A generated token',
	`meta` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'datetime of creation',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Store OpenWebAuth token to verify contacts';

--
-- TABLE parsed_url
--
CREATE TABLE IF NOT EXISTS `parsed_url` (
	`url` varbinary(255) NOT NULL COMMENT 'page url',
	`guessing` boolean NOT NULL DEFAULT '0' COMMENT 'is the \'guessing\' mode active?',
	`oembed` boolean NOT NULL DEFAULT '0' COMMENT 'is the data the result of oembed?',
	`content` mediumtext COMMENT 'page data',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'datetime of creation',
	 PRIMARY KEY(`url`,`guessing`,`oembed`),
	 INDEX `created` (`created`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='cache for \'parse_url\' queries';

--
-- TABLE participation
--
CREATE TABLE IF NOT EXISTS `participation` (
	`iid` int unsigned NOT NULL COMMENT '',
	`server` varchar(60) NOT NULL COMMENT '',
	`cid` int unsigned NOT NULL COMMENT '',
	`fid` int unsigned NOT NULL COMMENT '',
	 PRIMARY KEY(`iid`,`server`),
	 INDEX `cid` (`cid`),
	 INDEX `fid` (`fid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Storage for participation messages from Diaspora';

--
-- TABLE pconfig
--
CREATE TABLE IF NOT EXISTS `pconfig` (
	`id` int unsigned NOT NULL auto_increment COMMENT '',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`cat` varbinary(50) NOT NULL DEFAULT '' COMMENT '',
	`k` varbinary(100) NOT NULL DEFAULT '' COMMENT '',
	`v` mediumtext COMMENT '',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `uid_cat_k` (`uid`,`cat`,`k`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='personal (per user) configuration storage';

--
-- TABLE permissionset
--
CREATE TABLE IF NOT EXISTS `permissionset` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Owner id of this permission set',
	`allow_cid` mediumtext COMMENT 'Access Control - list of allowed contact.id \'<19><78>\'',
	`allow_gid` mediumtext COMMENT 'Access Control - list of allowed groups',
	`deny_cid` mediumtext COMMENT 'Access Control - list of denied contact.id',
	`deny_gid` mediumtext COMMENT 'Access Control - list of denied groups',
	 PRIMARY KEY(`id`),
	 INDEX `uid_allow_cid_allow_gid_deny_cid_deny_gid` (`allow_cid`(50),`allow_gid`(30),`deny_cid`(50),`deny_gid`(30))
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='';

--
-- TABLE photo
--
CREATE TABLE IF NOT EXISTS `photo` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Owner User id',
	`contact-id` int unsigned NOT NULL DEFAULT 0 COMMENT 'contact.id',
	`guid` char(16) NOT NULL DEFAULT '' COMMENT 'A unique identifier for this photo',
	`resource-id` char(32) NOT NULL DEFAULT '' COMMENT '',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'creation date',
	`edited` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'last edited date',
	`title` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`desc` text COMMENT '',
	`album` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the album to which the photo belongs',
	`filename` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`type` varchar(30) NOT NULL DEFAULT 'image/jpeg',
	`height` smallint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`width` smallint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`datasize` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`data` mediumblob NOT NULL COMMENT '',
	`scale` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`profile` boolean NOT NULL DEFAULT '0' COMMENT '',
	`allow_cid` mediumtext COMMENT 'Access Control - list of allowed contact.id \'<19><78>\'',
	`allow_gid` mediumtext COMMENT 'Access Control - list of allowed groups',
	`deny_cid` mediumtext COMMENT 'Access Control - list of denied contact.id',
	`deny_gid` mediumtext COMMENT 'Access Control - list of denied groups',
	`backend-class` tinytext COMMENT 'Storage backend class',
	`backend-ref` text COMMENT 'Storage backend data reference',
	`updated` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	 PRIMARY KEY(`id`),
	 INDEX `contactid` (`contact-id`),
	 INDEX `uid_contactid` (`uid`,`contact-id`),
	 INDEX `uid_profile` (`uid`,`profile`),
	 INDEX `uid_album_scale_created` (`uid`,`album`(32),`scale`,`created`),
	 INDEX `uid_album_resource-id_created` (`uid`,`album`(32),`resource-id`,`created`),
	 INDEX `resource-id` (`resource-id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='photo storage';

--
-- TABLE poll
--
CREATE TABLE IF NOT EXISTS `poll` (
	`id` int unsigned NOT NULL auto_increment COMMENT '',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`q0` text COMMENT '',
	`q1` text COMMENT '',
	`q2` text COMMENT '',
	`q3` text COMMENT '',
	`q4` text COMMENT '',
	`q5` text COMMENT '',
	`q6` text COMMENT '',
	`q7` text COMMENT '',
	`q8` text COMMENT '',
	`q9` text COMMENT '',
	 PRIMARY KEY(`id`),
	 INDEX `uid` (`uid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Currently unused table for storing poll results';

--
-- TABLE poll_result
--
CREATE TABLE IF NOT EXISTS `poll_result` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`poll_id` int unsigned NOT NULL DEFAULT 0,
	`choice` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	 PRIMARY KEY(`id`),
	 INDEX `poll_id` (`poll_id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='data for polls - currently unused';

--
-- TABLE process
--
CREATE TABLE IF NOT EXISTS `process` (
	`pid` int unsigned NOT NULL COMMENT '',
	`command` varbinary(32) NOT NULL DEFAULT '' COMMENT '',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	 PRIMARY KEY(`pid`),
	 INDEX `command` (`command`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Currently running system processes';

--
-- TABLE profile
--
CREATE TABLE IF NOT EXISTS `profile` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'Owner User id',
	`profile-name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name of the profile',
	`is-default` boolean NOT NULL DEFAULT '0' COMMENT 'Mark this profile as default profile',
	`hide-friends` boolean NOT NULL DEFAULT '0' COMMENT 'Hide friend list from viewers of this profile',
	`name` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`pdesc` varchar(255) NOT NULL DEFAULT '' COMMENT 'Title or description',
	`dob` varchar(32) NOT NULL DEFAULT '0000-00-00' COMMENT 'Day of birth',
	`address` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`locality` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`region` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`postal-code` varchar(32) NOT NULL DEFAULT '' COMMENT '',
	`country-name` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`hometown` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`gender` varchar(32) NOT NULL DEFAULT '' COMMENT '',
	`marital` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`with` text COMMENT '',
	`howlong` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`sexual` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`politic` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`religion` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`pub_keywords` text COMMENT '',
	`prv_keywords` text COMMENT '',
	`likes` text COMMENT '',
	`dislikes` text COMMENT '',
	`about` text COMMENT '',
	`summary` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`music` text COMMENT '',
	`book` text COMMENT '',
	`tv` text COMMENT '',
	`film` text COMMENT '',
	`interest` text COMMENT '',
	`romance` text COMMENT '',
	`work` text COMMENT '',
	`education` text COMMENT '',
	`contact` text COMMENT '',
	`homepage` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`xmpp` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`photo` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`thumb` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`publish` boolean NOT NULL DEFAULT '0' COMMENT 'publish default profile in local directory',
	`net-publish` boolean NOT NULL DEFAULT '0' COMMENT 'publish profile in global directory',
	 PRIMARY KEY(`id`),
	 INDEX `uid_is-default` (`uid`,`is-default`),
	 FULLTEXT INDEX `pub_keywords` (`pub_keywords`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='user profiles data';

--
-- TABLE profile_check
--
CREATE TABLE IF NOT EXISTS `profile_check` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`cid` int unsigned NOT NULL DEFAULT 0 COMMENT 'contact.id',
	`dfrn_id` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`sec` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`expire` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='DFRN remote auth use';

--
-- TABLE push_subscriber
--
CREATE TABLE IF NOT EXISTS `push_subscriber` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`callback_url` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`topic` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`push` tinyint NOT NULL DEFAULT 0 COMMENT 'Retrial counter',
	`last_update` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Date of last successful trial',
	`next_try` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Next retrial date',
	`renewed` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Date of last subscription renewal',
	`secret` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	 PRIMARY KEY(`id`),
	 INDEX `next_try` (`next_try`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Used for OStatus: Contains feed subscribers';

--
-- TABLE register
--
CREATE TABLE IF NOT EXISTS `register` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`hash` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`password` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`language` varchar(16) NOT NULL DEFAULT '' COMMENT '',
	`note` text COMMENT '',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='registrations requiring admin approval';

--
-- TABLE search
--
CREATE TABLE IF NOT EXISTS `search` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`term` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	 PRIMARY KEY(`id`),
	 INDEX `uid` (`uid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='';

--
-- TABLE session
--
CREATE TABLE IF NOT EXISTS `session` (
	`id` bigint unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`sid` varbinary(255) NOT NULL DEFAULT '' COMMENT '',
	`data` text COMMENT '',
	`expire` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	 PRIMARY KEY(`id`),
	 INDEX `sid` (`sid`(64)),
	 INDEX `expire` (`expire`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='web session storage';

--
-- TABLE sign
--
CREATE TABLE IF NOT EXISTS `sign` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`iid` int unsigned NOT NULL DEFAULT 0 COMMENT 'item.id',
	`signed_text` mediumtext COMMENT '',
	`signature` text COMMENT '',
	`signer` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	 PRIMARY KEY(`id`),
	 UNIQUE INDEX `iid` (`iid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Diaspora signatures';

--
-- TABLE term
--
CREATE TABLE IF NOT EXISTS `term` (
	`tid` int unsigned NOT NULL auto_increment COMMENT '',
	`oid` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`otype` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`type` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`term` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`url` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`guid` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`received` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`global` boolean NOT NULL DEFAULT '0' COMMENT '',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	 PRIMARY KEY(`tid`),
	 INDEX `term_type` (`term`(64),`type`),
	 INDEX `oid_otype_type_term` (`oid`,`otype`,`type`,`term`(32)),
	 INDEX `uid_otype_type_term_global_created` (`uid`,`otype`,`type`,`term`(32),`global`,`created`),
	 INDEX `uid_otype_type_url` (`uid`,`otype`,`type`,`url`(64)),
	 INDEX `guid` (`guid`(64))
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='item taxonomy (categories, tags, etc.) table';

--
-- TABLE thread
--
CREATE TABLE IF NOT EXISTS `thread` (
	`iid` int unsigned NOT NULL DEFAULT 0 COMMENT 'sequential ID',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`contact-id` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`owner-id` int unsigned NOT NULL DEFAULT 0 COMMENT 'Item owner',
	`author-id` int unsigned NOT NULL DEFAULT 0 COMMENT 'Item author',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`edited` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`commented` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`received` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`changed` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '',
	`wall` boolean NOT NULL DEFAULT '0' COMMENT '',
	`private` boolean NOT NULL DEFAULT '0' COMMENT '',
	`pubmail` boolean NOT NULL DEFAULT '0' COMMENT '',
	`moderated` boolean NOT NULL DEFAULT '0' COMMENT '',
	`visible` boolean NOT NULL DEFAULT '0' COMMENT '',
	`starred` boolean NOT NULL DEFAULT '0' COMMENT '',
	`ignored` boolean NOT NULL DEFAULT '0' COMMENT '',
	`post-type` tinyint unsigned NOT NULL DEFAULT 0 COMMENT 'Post type (personal note, bookmark, ...)',
	`unseen` boolean NOT NULL DEFAULT '1' COMMENT '',
	`deleted` boolean NOT NULL DEFAULT '0' COMMENT '',
	`origin` boolean NOT NULL DEFAULT '0' COMMENT '',
	`forum_mode` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`mention` boolean NOT NULL DEFAULT '0' COMMENT '',
	`network` char(4) NOT NULL DEFAULT '' COMMENT '',
	`bookmark` boolean COMMENT '',
	 PRIMARY KEY(`iid`),
	 INDEX `uid_network_commented` (`uid`,`network`,`commented`),
	 INDEX `uid_network_received` (`uid`,`network`,`received`),
	 INDEX `uid_contactid_commented` (`uid`,`contact-id`,`commented`),
	 INDEX `uid_contactid_received` (`uid`,`contact-id`,`received`),
	 INDEX `contactid` (`contact-id`),
	 INDEX `ownerid` (`owner-id`),
	 INDEX `authorid` (`author-id`),
	 INDEX `uid_received` (`uid`,`received`),
	 INDEX `uid_commented` (`uid`,`commented`),
	 INDEX `uid_wall_received` (`uid`,`wall`,`received`),
	 INDEX `private_wall_origin_commented` (`private`,`wall`,`origin`,`commented`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Thread related data';

--
-- TABLE tokens
--
CREATE TABLE IF NOT EXISTS `tokens` (
	`id` varchar(40) NOT NULL COMMENT '',
	`secret` text COMMENT '',
	`client_id` varchar(20) NOT NULL DEFAULT '',
	`expires` int NOT NULL DEFAULT 0 COMMENT '',
	`scope` varchar(200) NOT NULL DEFAULT '' COMMENT '',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='OAuth usage';

--
-- TABLE user
--
CREATE TABLE IF NOT EXISTS `user` (
	`uid` mediumint unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`parent-uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'The parent user that has full control about this user',
	`guid` varchar(64) NOT NULL DEFAULT '' COMMENT 'A unique identifier for this user',
	`username` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name that this user is known by',
	`password` varchar(255) NOT NULL DEFAULT '' COMMENT 'encrypted password',
	`legacy_password` boolean NOT NULL DEFAULT '0' COMMENT 'Is the password hash double-hashed?',
	`nickname` varchar(255) NOT NULL DEFAULT '' COMMENT 'nick- and user name',
	`email` varchar(255) NOT NULL DEFAULT '' COMMENT 'the users email address',
	`openid` varchar(255) NOT NULL DEFAULT '' COMMENT '',
	`timezone` varchar(128) NOT NULL DEFAULT '' COMMENT 'PHP-legal timezone',
	`language` varchar(32) NOT NULL DEFAULT 'en' COMMENT 'default language',
	`register_date` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'timestamp of registration',
	`login_date` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'timestamp of last login',
	`default-location` varchar(255) NOT NULL DEFAULT '' COMMENT 'Default for item.location',
	`allow_location` boolean NOT NULL DEFAULT '0' COMMENT '1 allows to display the location',
	`theme` varchar(255) NOT NULL DEFAULT '' COMMENT 'user theme preference',
	`pubkey` text COMMENT 'RSA public key 4096 bit',
	`prvkey` text COMMENT 'RSA private key 4096 bit',
	`spubkey` text COMMENT '',
	`sprvkey` text COMMENT '',
	`verified` boolean NOT NULL DEFAULT '0' COMMENT 'user is verified through email',
	`blocked` boolean NOT NULL DEFAULT '0' COMMENT '1 for user is blocked',
	`blockwall` boolean NOT NULL DEFAULT '0' COMMENT 'Prohibit contacts to post to the profile page of the user',
	`hidewall` boolean NOT NULL DEFAULT '0' COMMENT 'Hide profile details from unkown viewers',
	`blocktags` boolean NOT NULL DEFAULT '0' COMMENT 'Prohibit contacts to tag the post of this user',
	`unkmail` boolean NOT NULL DEFAULT '0' COMMENT 'Permit unknown people to send private mails to this user',
	`cntunkmail` int unsigned NOT NULL DEFAULT 10 COMMENT '',
	`notify-flags` smallint unsigned NOT NULL DEFAULT 65535 COMMENT 'email notification options',
	`page-flags` tinyint unsigned NOT NULL DEFAULT 0 COMMENT 'page/profile type',
	`account-type` tinyint unsigned NOT NULL DEFAULT 0 COMMENT '',
	`prvnets` boolean NOT NULL DEFAULT '0' COMMENT '',
	`pwdreset` varchar(255) COMMENT 'Password reset request token',
	`pwdreset_time` datetime COMMENT 'Timestamp of the last password reset request',
	`maxreq` int unsigned NOT NULL DEFAULT 10 COMMENT '',
	`expire` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`account_removed` boolean NOT NULL DEFAULT '0' COMMENT 'if 1 the account is removed',
	`account_expired` boolean NOT NULL DEFAULT '0' COMMENT '',
	`account_expires_on` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'timestamp when account expires and will be deleted',
	`expire_notification_sent` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'timestamp of last warning of account expiration',
	`def_gid` int unsigned NOT NULL DEFAULT 0 COMMENT '',
	`allow_cid` mediumtext COMMENT 'default permission for this user',
	`allow_gid` mediumtext COMMENT 'default permission for this user',
	`deny_cid` mediumtext COMMENT 'default permission for this user',
	`deny_gid` mediumtext COMMENT 'default permission for this user',
	`openidserver` text COMMENT '',
	 PRIMARY KEY(`uid`),
	 INDEX `nickname` (`nickname`(32))
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='The local users';

--
-- TABLE userd
--
CREATE TABLE IF NOT EXISTS `userd` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'sequential ID',
	`username` varchar(255) NOT NULL COMMENT '',
	 PRIMARY KEY(`id`),
	 INDEX `username` (`username`(32))
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Deleted usernames';

--
-- TABLE user-contact
--
CREATE TABLE IF NOT EXISTS `user-contact` (
	`cid` int unsigned NOT NULL DEFAULT 0 COMMENT 'Contact id of the linked public contact',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`blocked` boolean COMMENT 'Contact is completely blocked for this user',
	`ignored` boolean COMMENT 'Posts from this contact are ignored',
	`collapsed` boolean COMMENT 'Posts from this contact are collapsed',
	 PRIMARY KEY(`uid`,`cid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='User specific public contact data';

--
-- TABLE user-item
--
CREATE TABLE IF NOT EXISTS `user-item` (
	`iid` int unsigned NOT NULL DEFAULT 0 COMMENT 'Item id',
	`uid` mediumint unsigned NOT NULL DEFAULT 0 COMMENT 'User id',
	`hidden` boolean NOT NULL DEFAULT '0' COMMENT 'Marker to hide an item from the user',
	`ignored` boolean COMMENT 'Ignore this thread if set',
	 PRIMARY KEY(`uid`,`iid`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='User specific item data';

--
-- TABLE worker-ipc
--
CREATE TABLE IF NOT EXISTS `worker-ipc` (
	`key` int NOT NULL COMMENT '',
	`jobs` boolean COMMENT 'Flag for outstanding jobs',
	 PRIMARY KEY(`key`)
) ENGINE=MEMORY DEFAULT COLLATE utf8mb4_general_ci COMMENT='Inter process communication between the frontend and the worker';

--
-- TABLE workerqueue
--
CREATE TABLE IF NOT EXISTS `workerqueue` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'Auto incremented worker task id',
	`parameter` mediumtext COMMENT 'Task command',
	`priority` tinyint unsigned NOT NULL DEFAULT 0 COMMENT 'Task priority',
	`created` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Creation date',
	`pid` int unsigned NOT NULL DEFAULT 0 COMMENT 'Process id of the worker',
	`executed` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Execution date',
	`next_try` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT 'Next retrial date',
	`retrial` tinyint NOT NULL DEFAULT 0 COMMENT 'Retrial counter',
	`done` boolean NOT NULL DEFAULT '0' COMMENT 'Marked 1 when the task was done - will be deleted later',
	 PRIMARY KEY(`id`),
	 INDEX `done_parameter` (`done`,`parameter`(64)),
	 INDEX `done_executed` (`done`,`executed`),
	 INDEX `done_priority_created` (`done`,`priority`,`created`),
	 INDEX `done_priority_next_try` (`done`,`priority`,`next_try`),
	 INDEX `done_pid_next_try` (`done`,`pid`,`next_try`),
	 INDEX `done_pid_priority_created` (`done`,`pid`,`priority`,`created`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Background tasks queue entries';

--
-- TABLE storage
--
CREATE TABLE IF NOT EXISTS `storage` (
	`id` int unsigned NOT NULL auto_increment COMMENT 'Auto incremented image data id',
	`data` longblob NOT NULL COMMENT 'file data',
	 PRIMARY KEY(`id`)
) DEFAULT COLLATE utf8mb4_general_ci COMMENT='Data stored by Database storage backend';


