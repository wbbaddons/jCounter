#!/usr/bin/env php
<?php
namespace be\bastelstu\max\wcf\jCounter;
/**
 * Builds jCounter
 *
 * @author 	Tim Düsterhus
 * @copyright	2010-2013 Tim Düsterhus
 * @license	Creative Commons Attribution-NonCommercial-ShareAlike <http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode>
 * @package	be.bastelstu.max.wcf.jCounter
 */
$packageXML = file_get_contents('package.xml');
preg_match('/<version>(.*?)<\/version>/', $packageXML, $matches);
echo "Building jCounter $matches[1]\n";
echo str_repeat("=", strlen("Building jCounter $matches[1]"))."\n";

echo <<<EOT
Cleaning up
-----------

EOT;
	if (file_exists('package.xml.old')) {
		file_put_contents('package.xml', file_get_contents('package.xml.old'));
		unlink('package.xml.old');
	}
	if (file_exists('file.tar')) unlink('file.tar');
	foreach (glob('file/js/*.js') as $jsFile) unlink($jsFile);
	if (file_exists('be.bastelstu.max.jCounter.tar')) unlink('be.bastelstu.max.wcf.jCounter.tar');
echo <<<EOT

Building JavaScript
-------------------

EOT;
foreach (glob('file/js/*.coffee') as $coffeeFile) {
	echo $coffeeFile."\n";
	passthru('coffee -cb '.escapeshellarg($coffeeFile), $code);
	if ($code != 0) exit($code);
}
echo <<<EOT

Building file.tar
-----------------

EOT;
	chdir('file');
	passthru('tar cvf ../file.tar --exclude=*.coffee -- *', $code);
	if ($code != 0) exit($code);
echo <<<EOT

Building be.bastelstu.max.jCounter.tar
--------------------------------------

EOT;
	chdir('..');
	file_put_contents('package.xml.old', file_get_contents('package.xml'));
	file_put_contents('package.xml', preg_replace('~<date>\d{4}-\d{2}-\d{2}</date>~', '<date>'.date('Y-m-d').'</date>', file_get_contents('package.xml')));
	passthru('tar cvf be.bastelstu.max.wcf.jCounter.tar --exclude=*.old --exclude=file --exclude=template --exclude=acptemplate --exclude=contrib -- *', $code);
	if (file_exists('package.xml.old')) {
		file_put_contents('package.xml', file_get_contents('package.xml.old'));
		unlink('package.xml.old');
	}
	if ($code != 0) exit($code);

if (file_exists('file.tar')) unlink('file.tar');
foreach (glob('file/js/*.js') as $jsFile) unlink($jsFile);
