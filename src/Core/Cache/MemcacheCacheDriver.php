<?php

namespace Friendica\Core\Cache;

use Friendica\BaseObject;
use Friendica\Core\Cache;

/**
 * Memcache Cache Driver
 *
 * @author Hypolite Petovan <mrpetovan@gmail.com>
 */
class MemcacheCacheDriver extends BaseObject implements IMemoryCacheDriver
{
	use TraitCompareSet;
	use TraitCompareDelete;

	/**
	 * @var \Memcache
	 */
	private $memcache;

	public function __construct($memcache_host, $memcache_port)
	{
		if (!class_exists('Memcache', false)) {
			throw new \Exception('Memcache class isn\'t available');
		}

		$this->memcache = new \Memcache();

		if (!$this->memcache->connect($memcache_host, $memcache_port)) {
			throw new \Exception('Expected Memcache server at ' . $memcache_host . ':' . $memcache_port . ' isn\'t available');
		}
	}

	/**
	 * (@inheritdoc)
	 */
	public function get($key)
	{
		$return = null;

		// We fetch with the hostname as key to avoid problems with other applications
		$cached = $this->memcache->get(self::getApp()->get_hostname() . ':' . $key);

		// @see http://php.net/manual/en/memcache.get.php#84275
		if (is_bool($cached) || is_double($cached) || is_long($cached)) {
			return $return;
		}

		$value = @unserialize($cached);

		// Only return a value if the serialized value is valid.
		// We also check if the db entry is a serialized
		// boolean 'false' value (which we want to return).
		if ($cached === serialize(false) || $value !== false) {
			$return = $value;
		}

		return $return;
	}

	/**
	 * (@inheritdoc)
	 */
	public function set($key, $value, $ttl = Cache::FIVE_MINUTES)
	{
		// We store with the hostname as key to avoid problems with other applications
		if ($ttl > 0) {
			return $this->memcache->set(
				self::getApp()->get_hostname() . ":" . $key,
				serialize($value),
				MEMCACHE_COMPRESSED,
				time() + $ttl
			);
		} else {
			return $this->memcache->set(
				self::getApp()->get_hostname() . ":" . $key,
				serialize($value),
				MEMCACHE_COMPRESSED
			);
		}
	}

	/**
	 * (@inheritdoc)
	 */
	public function delete($key)
	{
		return $this->memcache->delete($key);
	}

	public function clear()
	{
		return $this->memcache->flush();
	}

	/**
	 * (@inheritdoc)
	 */
	public function add($key, $value, $ttl = Cache::FIVE_MINUTES)
	{
		return $this->memcache->add(self::getApp()->get_hostname() . ":" . $key, $value, $ttl);
	}
}
