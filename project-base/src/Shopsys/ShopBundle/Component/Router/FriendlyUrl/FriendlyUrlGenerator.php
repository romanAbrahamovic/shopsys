<?php

namespace Shopsys\ShopBundle\Component\Router\FriendlyUrl;

use Shopsys\ShopBundle\Component\Domain\Config\DomainConfig;
use Shopsys\ShopBundle\Component\Router\FriendlyUrl\FriendlyUrl;
use Shopsys\ShopBundle\Component\Router\FriendlyUrl\FriendlyUrlRepository;
use Symfony\Component\Routing\Generator\UrlGenerator as BaseUrlGenerator;
use Symfony\Component\Routing\RequestContext;
use Symfony\Component\Routing\Route;
use Symfony\Component\Routing\RouteCollection;
use Symfony\Component\Routing\RouteCompiler;

class FriendlyUrlGenerator extends BaseUrlGenerator {

	/**
	 * @var \Symfony\Component\Routing\RouteCompiler
	 */
	private $routeCompiler;

	/**
	 * @var FriendlyUrlRepository
	 */
	private $friendlyUrlRepository;

	public function __construct(
		RequestContext $context,
		RouteCompiler $routeCompiler,
		FriendlyUrlRepository $friendlyUrlRepository
	) {
		parent::__construct(new RouteCollection(), $context, null);

		$this->routeCompiler = $routeCompiler;
		$this->friendlyUrlRepository = $friendlyUrlRepository;
	}

	/**
	 * @param \Symfony\Component\Routing\RouteCollection $routeCollection
	 * @param \Shopsys\ShopBundle\Component\Domain\Config\DomainConfig $domainConfig
	 * @param string $routeName
	 * @param array $parameters
	 * @param string $referenceType
	 * @return string
	 */
	public function generateFromRouteCollection(
		RouteCollection $routeCollection,
		DomainConfig $domainConfig,
		$routeName,
		array $parameters = [],
		$referenceType = self::ABSOLUTE_PATH
	) {
		$route = $routeCollection->get($routeName);
		if ($route === null) {
			$message = 'Unable to generate a URL for the named route "' . $routeName . '" as such route does not exist.';
			throw new \Symfony\Component\Routing\Exception\RouteNotFoundException($message);
		}
		if (!array_key_exists('id', $parameters)) {
			$message = 'Missing mandatory parameter "id" for route ' . $routeName . '.';
			throw new \Symfony\Component\Routing\Exception\MissingMandatoryParametersException($message);
		}
		$entityId = $parameters['id'];
		unset($parameters['id']);

		try {
			$friendlyUrl = $this->friendlyUrlRepository->getMainFriendlyUrl(
				$domainConfig->getId(),
				$routeName,
				$entityId
			);
		} catch (\Shopsys\ShopBundle\Component\Router\FriendlyUrl\Exception\FriendlyUrlNotFoundException $e) {
			$message = 'Unable to generate a URL for the named route "' . $routeName . '" as such route does not exist.';
			throw new \Symfony\Component\Routing\Exception\RouteNotFoundException($message, 0, $e);
		}

		return $this->getGeneratedUrl($routeName, $route, $friendlyUrl, $parameters, $referenceType);
	}

	/**
	 * @param string $routeName
	 * @param \Symfony\Component\Routing\Route $route
	 * @param \Shopsys\ShopBundle\Component\Router\FriendlyUrl\FriendlyUrl $friendlyUrl
	 * @param array $parameters
	 * @param string $referenceType
	 * @return string
	 */
	public function getGeneratedUrl($routeName, Route $route, FriendlyUrl $friendlyUrl, array $parameters, $referenceType) {
		$compiledRoute = $this->routeCompiler->compile($route);

		$tokens = [
			[
				0 => 'text',
				1 => '/' . $friendlyUrl->getSlug(),
			],
		];

		return $this->doGenerate(
			$compiledRoute->getVariables(),
			$route->getDefaults(),
			$route->getRequirements(),
			$tokens,
			$parameters,
			$routeName,
			$referenceType,
			$compiledRoute->getHostTokens(),
			$route->getSchemes()
		);
	}

	/**
	 * Not supproted method
	 */
	public function generate($routeName, $parameters = [], $referenceType = self::ABSOLUTE_PATH) {
		throw new \Shopsys\ShopBundle\Component\Router\FriendlyUrl\Exception\MethodGenerateIsNotSupportedException();
	}

}
